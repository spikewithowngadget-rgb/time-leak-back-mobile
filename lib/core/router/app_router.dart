import 'package:auto_route/auto_route.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    /// Календарь — начальная точка. Если гвард не пустит, сработает редирект.
    AutoRoute(page: CalendarRoute.page, initial: true, guards: [AuthGuard()]),

    /// Страница логина
    AutoRoute(page: LoginRoute.page),

    AutoRoute(page: RegisterPhoneRoute.page),
    AutoRoute(page: RegisterVerifyRoute.page),
    AutoRoute(page: RegisterPasswordRoute.page),

    AutoRoute(page: CreateNewPasswordRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: ResetVerifyRoute.page),
  ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // Получаем базу данных из GetIt
    final db = sl<AppDatabase>();

    // Проверяем наличие сессии (токенов)
    final session = await db.getTokens();

    if (session != null) {
      // Токен есть — разрешаем переход
      resolver.next(true);
    } else {
      // Токена нет — прерываем навигацию и редиректим на Login
      router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}
