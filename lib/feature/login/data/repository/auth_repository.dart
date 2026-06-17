import 'package:dio/dio.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/feature/register/data/models/register_models.dart';

String _messageFromDioException(DioException e, {String? fallback}) {
  final data = e.response?.data;
  if (data is Map) {
    final err = data['error'] ?? data['message'] ?? data['detail'];
    if (err != null) return err.toString();
  }
  if (data is String && data.isNotEmpty) return data;
  if (e.message != null && e.message!.isNotEmpty) return e.message!;
  return fallback ?? 'Ошибка запроса';
}

/// Бросается, если бэкенд ответил 403 "account_deactivated" при логине/обновлении.
class AccountDeactivatedException implements Exception {
  final String message;
  AccountDeactivatedException([this.message = 'Аккаунт отключён']);

  @override
  String toString() => message;
}

class AuthRepository {
  final Dio _dio;
  final AppDatabase _db;

  AuthRepository(this._dio, this._db);

  /// Выполняет вход и сохраняет токены в базу данных.
  /// Поддерживает опциональный [verificationToken] (purpose=login),
  /// а также данные [device] и [location] для backend audit.
  Future<void> login({
    required String phone,
    required String password,
    String? verificationToken,
    Map<String, dynamic>? device,
    Map<String, dynamic>? location,
  }) async {
    try {
      final body = <String, dynamic>{
        'phone': phone,
        'password': password,
        if (verificationToken != null) 'verification_token': verificationToken,
        if (device != null) 'device': device,
        if (location != null) 'location': location,
      };
      final response = await _dio.post('/api/v1/auth/login', data: body);

      final String accessToken = response.data['access_token'] as String;
      final String refreshToken = response.data['refresh_token'] as String;

      await _db.updateTokens(accessToken, refreshToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw AccountDeactivatedException(_messageFromDioException(e, fallback: 'Аккаунт отключён'));
      }
      throw _messageFromDioException(e, fallback: 'Ошибка авторизации');
    } catch (e) {
      throw 'Произошла непредвиденная ошибка';
    }
  }

  /// Запросить WhatsApp OTP (теперь строго purpose=registration на бэке).
  Future<OtpRequestResponse> requestOtp(String phone) async {
    try {
      final response = await _dio.post('/api/v1/auth/otp/request', data: {'phone': phone});
      return OtpRequestResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Не удалось отправить код');
    }
  }

  /// Запросить Telegram OTP. [purpose] — registration / login / password_reset.
  /// В ответе придёт [OtpRequestResponse.telegramDeepLink] — ссылку нужно открыть в Telegram.
  Future<OtpRequestResponse> requestTelegramOtp({
    required String phone,
    required String purpose,
    Map<String, dynamic>? device,
    Map<String, dynamic>? location,
  }) async {
    try {
      final body = <String, dynamic>{
        'phone': phone,
        'purpose': purpose,
        if (device != null) 'device': device,
        if (location != null) 'location': location,
      };
      final response = await _dio.post('/api/v1/auth/telegram-otp/request', data: body);
      return OtpRequestResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Не удалось создать Telegram OTP сессию');
    }
  }

  /// Верификация OTP (registration или login).
  Future<OtpVerifyResponse> verifyOtp(String requestId, String code) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/otp/verify',
        data: {'request_id': requestId, 'code': code},
      );
      return OtpVerifyResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Неверный код');
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String confirmPassword,
    required String verificationToken,
    Map<String, dynamic>? device,
    Map<String, dynamic>? location,
  }) async {
    try {
      final body = <String, dynamic>{
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'verification_token': verificationToken,
        if (device != null) 'device': device,
        if (location != null) 'location': location,
      };
      await _dio.post('/api/v1/auth/register', data: body);
    } on DioException catch (e) {
      throw _messageFromDioException(e);
    }
  }

  Future<OtpRequestResponse> requestPasswordResetOtp(String phone) async {
    try {
      final response = await _dio.post('/api/v1/auth/password-reset/otp/request', data: {'phone': phone});
      return OtpRequestResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Не удалось отправить код');
    }
  }

  /// Верификация OTP для сброса пароля (теперь принимает только purpose=password_reset).
  Future<OtpVerifyResponse> verifyPasswordResetOtp(String requestId, String code) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/password-reset/otp/verify',
        data: {'request_id': requestId, 'code': code},
      );
      return OtpVerifyResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Неверный код');
    }
  }

  Future<void> confirmPasswordReset({
    required String phone,
    required String newPassword,
    required String confirmPassword,
    required String verificationToken,
    Map<String, dynamic>? device,
    Map<String, dynamic>? location,
  }) async {
    try {
      final body = <String, dynamic>{
        'phone': phone,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
        'verification_token': verificationToken,
        if (device != null) 'device': device,
        if (location != null) 'location': location,
      };
      await _dio.post('/api/v1/auth/password-reset/confirm', data: body);
    } on DioException catch (e) {
      throw _messageFromDioException(e, fallback: 'Не удалось сменить пароль');
    }
  }

  /// Метод для выхода (удаление токенов из БД).
  Future<void> logout() async {
    PinSession.reset();
    await _db.clearPinHash();
    await _db.deleteTokens();
  }
}
