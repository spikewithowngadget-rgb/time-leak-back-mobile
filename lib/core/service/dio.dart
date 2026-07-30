import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/feature/notification/app_icon_badge_service.dart';

/// Ошибка обновления токена.
/// [isPermanent] = true только когда refresh точно мёртв (401/403 / нет токена) —
/// тогда можно разлогинить. Иначе сессию сохраняем.
class _AuthRefreshException implements Exception {
  final String message;
  final bool isPermanent;
  final Object? cause;

  const _AuthRefreshException(this.message, {required this.isPermanent, this.cause});

  factory _AuthRefreshException.permanent(String message, [Object? cause]) =>
      _AuthRefreshException(message, isPermanent: true, cause: cause);

  factory _AuthRefreshException.transient(String message, [Object? cause]) =>
      _AuthRefreshException(message, isPermanent: false, cause: cause);

  @override
  String toString() => message;
}

class DioClient {
  late final Dio dio;
  final AppDatabase db;

  /// Один общий refresh: бэк ротирует refresh-токен, параллельные 401
  /// должны делить один вызов, а не слать один и тот же refresh дважды.
  Future<String>? _refreshFuture;

  /// Анти-дубль принудительного логаута при пачке 401.
  Future<void>? _logoutFuture;

  static const _refreshAttempts = 3;

  DioClient(this.db) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.timeleak.kz',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains('/auth/refresh')) {
            return handler.next(options);
          }

          final tokens = await db.getTokens();
          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final status = e.response?.statusCode;
          final path = e.requestOptions.path;

          // 403 account_deactivated — сессия закрыта на бэке.
          if (status == 403 &&
              !path.contains('/auth/login') &&
              !path.contains('/auth/register') &&
              !path.contains('/auth/password-reset/')) {
            final data = e.response?.data;
            final errCode = data is Map ? (data['error'] ?? data['code'])?.toString() : null;
            if (errCode == 'account_deactivated') {
              await _forceLogout(clearPin: true);
            }
            return handler.next(e);
          }

          // 401 — до последнего стараемся обновить access через refresh.
          if (status == 401 &&
              !path.contains('/auth/login') &&
              !path.contains('/auth/refresh') &&
              !path.contains('/auth/register') &&
              !path.contains('/auth/password-reset/')) {
            // Уже ретраили с новым access — дальше только если refresh мёртв.
            if (e.requestOptions.extra['authRetried'] == true) {
              await _forceLogout();
              return handler.next(e);
            }

            try {
              final newAccess = await _refreshAccessToken();
              e.requestOptions.extra['authRetried'] = true;
              e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
              final retryResponse = await dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } on _AuthRefreshException catch (err) {
              debugPrint('Token refresh failed (permanent=${err.isPermanent}): $err');
              if (err.isPermanent) {
                await _forceLogout();
              }
              // Transient (сеть/5xx): токены не трогаем — следующий запрос снова попробует.
              return handler.next(e);
            } catch (err, st) {
              // Неожиданная ошибка (в т.ч. сеть на retry) — сессию не сбрасываем.
              debugPrint('Token refresh/retry unexpected: $err\n$st');
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<String> _refreshAccessToken() {
    _refreshFuture ??= _performTokenRefresh().whenComplete(() {
      _refreshFuture = null;
    });
    return _refreshFuture!;
  }

  Future<String> _performTokenRefresh() async {
    final tokens = await db.getTokens();
    if (tokens == null || tokens.refreshToken.isEmpty) {
      throw _AuthRefreshException.permanent('No refresh token');
    }

    DioException? lastNetworkError;

    for (var attempt = 0; attempt < _refreshAttempts; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
      }

      try {
        final response = await dio.post(
          '/api/v1/auth/refresh',
          data: {'refresh_token': tokens.refreshToken},
        );

        final data = response.data;
        if (data is! Map) {
          throw _AuthRefreshException.permanent('Invalid refresh response shape');
        }

        final newAccess = data['access_token']?.toString();
        final newRefresh = data['refresh_token']?.toString();
        if (newAccess == null ||
            newAccess.isEmpty ||
            newRefresh == null ||
            newRefresh.isEmpty) {
          throw _AuthRefreshException.permanent('Refresh response missing tokens');
        }

        await db.updateTokens(newAccess, newRefresh);
        return newAccess;
      } on _AuthRefreshException {
        rethrow;
      } on DioException catch (e) {
        final status = e.response?.statusCode;

        // Refresh отвергнут бэком — сессия реально кончилась.
        if (status == 401 || status == 403) {
          throw _AuthRefreshException.permanent('Refresh rejected by server', e);
        }

        lastNetworkError = e;
        final transient = _isTransientDioError(e);
        if (!transient) {
          // Неожиданный 4xx (кроме 401/403) — не выкидываем пользователя.
          throw _AuthRefreshException.transient('Refresh failed', e);
        }
        // Иначе ещё попытка.
      }
    }

    throw _AuthRefreshException.transient(
      'Refresh failed after $_refreshAttempts attempts',
      lastNetworkError,
    );
  }

  bool _isTransientDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        return status != null && status >= 500;
      default:
        return false;
    }
  }

  Future<void> _forceLogout({bool clearPin = false}) {
    return _logoutFuture ??= _doForceLogout(clearPin: clearPin).whenComplete(() {
      _logoutFuture = null;
    });
  }

  Future<void> _doForceLogout({required bool clearPin}) async {
    PinSession.reset();
    if (clearPin) {
      await db.clearPinHash();
    }
    await db.deleteTokens();
    await sl<AppIconBadgeService>().clear();
    sl<AppRouter>().replaceAll([const LoginRoute()]);
  }
}
