import 'package:dio/dio.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';

class DioClient {
  late final Dio dio;
  final AppDatabase db;

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
          // Если мы идем обновлять токен, не нужно добавлять заголовок Auth
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
          // Если 401 и это не попытка логина/рефреша
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('/auth/login') &&
              !e.requestOptions.path.contains('/auth/refresh')) {
            final tokens = await db.getTokens();

            if (tokens != null) {
              try {
                // Запрос на рефреш
                final response = await dio.post(
                  '/api/v1/auth/refresh',
                  data: {'refresh_token': tokens.refreshToken},
                );

                final newAccess = response.data['access_token'];
                final newRefresh = response.data['refresh_token'];

                // Сохраняем новые данные в базу
                await db.updateTokens(newAccess, newRefresh);

                // Повторяем упавший запрос с новым токеном
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              } catch (refreshError) {
                await db.deleteTokens();
                sl<AppRouter>().replaceAll([const LoginRoute()]);
                return handler.next(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
