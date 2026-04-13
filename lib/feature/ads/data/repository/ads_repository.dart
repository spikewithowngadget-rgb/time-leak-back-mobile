import 'package:dio/dio.dart';
import 'package:time_leak_flutter/feature/ads/data/model/ad_model.dart';

/// Репозиторий рекламы: GET /api/v1/ads/next.
class AdsRepository {
  final Dio _dio;

  AdsRepository(this._dio);

  static const String _path = '/api/v1/ads/next';

  /// Получить следующую рекламу для авторизованного пользователя.
  /// Возвращает null, если 204 (нет активной рекламы) или ошибка.
  Future<AdModel?> getNextAd() async {
    try {
      final response = await _dio.get(_path);
      if (response.statusCode == 204 || response.data == null) return null;
      return AdModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return null;
      return null;
    }
  }
}
