import 'package:dio/dio.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/feature/register/data/models/register_models.dart';

class AuthRepository {
  final Dio _dio;
  final AppDatabase _db;

  AuthRepository(this._dio, this._db);

  /// Выполняет вход и сохраняет токены в базу данных
  Future<void> login({required String phone, required String password}) async {
    try {
      final response = await _dio.post('/api/v1/auth/login', data: {'phone': phone, 'password': password});

      // Извлекаем токены (согласно твоему JSON ответу)
      final String accessToken = response.data['access_token'];
      final String refreshToken = response.data['refresh_token'];

      // Сохраняем в Drift через созданный нами ранее метод
      await _db.updateTokens(accessToken, refreshToken);
    } on DioException catch (e) {
      // Извлекаем сообщение об ошибке от сервера, если оно есть
      final errorMessage = e.response?.data['message'] ?? 'Ошибка авторизации';
      throw errorMessage;
    } catch (e) {
      throw 'Произошла непредвиденная ошибка';
    }
  }

  Future<OtpRequestResponse> requestOtp(String phone) async {
    final response = await _dio.post('/api/v1/auth/otp/request', data: {'phone': phone});
    return OtpRequestResponse.fromJson(response.data);
  }

  Future<OtpVerifyResponse> verifyOtp(String requestId, String code) async {
    final response = await _dio.post(
      '/api/v1/auth/otp/verify',
      data: {'request_id': requestId, 'code': code},
    );
    return OtpVerifyResponse.fromJson(response.data);
  }

  Future<void> register({
    required String phone,
    required String password,
    required String confirmPassword,
    required String verificationToken,
  }) async {
    await _dio.post(
      '/api/v1/auth/register',
      data: {
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'verification_token': verificationToken,
      },
    );
  }

  Future<OtpRequestResponse> requestPasswordResetOtp(String phone) async {
    final response = await _dio.post('/api/v1/auth/password-reset/otp/request', data: {'phone': phone});
    return OtpRequestResponse.fromJson(response.data);
  }

  // 2. Верификация OTP для сброса
  Future<OtpVerifyResponse> verifyPasswordResetOtp(String requestId, String code) async {
    final response = await _dio.post(
      '/api/v1/auth/password-reset/otp/verify',
      data: {'request_id': requestId, 'code': code},
    );
    return OtpVerifyResponse.fromJson(response.data);
  }

  // 3. Подтверждение нового пароля
  Future<void> confirmPasswordReset({
    required String phone,
    required String newPassword,
    required String confirmPassword,
    required String verificationToken,
  }) async {
    await _dio.post(
      '/api/v1/auth/password-reset/confirm',
      data: {
        'phone': phone,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
        'verification_token': verificationToken,
      },
    );
  }

  /// Метод для выхода (удаление токенов из БД)
  Future<void> logout() async {
    await _db.deleteTokens();
  }
}
