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
}
