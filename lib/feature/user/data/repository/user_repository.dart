import 'package:dio/dio.dart';
import 'package:time_leak_flutter/feature/user/data/model/user_mode.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/api/v1/me');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Ошибка при получении профиля';
    }
  }

  /// Soft-delete: сервер выставляет isActive=false; пользователь не удаляется из БД.
  Future<void> deactivateUser(String userId) async {
    try {
      final response = await _dio.delete(
        '/api/delete/user',
        data: <String, dynamic>{'user_id': userId},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'deactivated') {
        return;
      }
      throw 'Unexpected response';
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final data = e.response?.data;
      String? serverMsg;
      if (data is Map) {
        final m = data['message'] ?? data['detail'] ?? data['error'];
        if (m != null) serverMsg = m.toString();
      }
      throw DeactivateUserException(statusCode: code, serverMessage: serverMsg);
    }
  }
}

/// Ошибка вызова DELETE /api/delete/user (403 = нет прав, см. требования к токену на бэкенде).
class DeactivateUserException implements Exception {
  const DeactivateUserException({this.statusCode, this.serverMessage});

  final int? statusCode;
  final String? serverMessage;

  bool get isForbidden => statusCode == 403;

  @override
  String toString() => serverMessage ?? 'HTTP ${statusCode ?? '?'}';
}
