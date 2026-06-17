import 'package:dio/dio.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';

class DioClient {
  late final Dio dio;
  final AppDatabase db;

  /// Single in-flight refresh: backend rotates refresh tokens, so parallel
  /// 401 handlers must share one refresh call instead of each sending the same token.
  Future<String>? _refreshFuture;

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

          // 403 account_deactivated — бэк закрывает все refresh tokens.
          // Чистим локальные токены/пин и выкидываем на логин, кроме самого логина
          // (там 403 обрабатывает AuthRepository как AccountDeactivatedException).
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

          // 401 — пробуем обновить токен (но не на логине/рефреше/регистрации).
          if (status == 401 &&
              !path.contains('/auth/login') &&
              !path.contains('/auth/refresh') &&
              !path.contains('/auth/register')) {
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
            } catch (_) {
              // Refresh не прошёл (401 — пользователь отключён, либо token больше не валиден):
              // бэк ротуирует refresh и закрывает старый, так что повторно не пробуем.
              await _forceLogout();
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
    if (tokens == null) {
      throw StateError('No refresh token');
    }

    final response = await dio.post(
      '/api/v1/auth/refresh',
      data: {'refresh_token': tokens.refreshToken},
    );

    final newAccess = response.data['access_token'] as String;
    final newRefresh = response.data['refresh_token'] as String;
    await db.updateTokens(newAccess, newRefresh);
    return newAccess;
  }

  Future<void> _forceLogout({bool clearPin = false}) async {
    PinSession.reset();
    if (clearPin) {
      await db.clearPinHash();
    }
    await db.deleteTokens();
    sl<AppRouter>().replaceAll([const LoginRoute()]);
  }
}
