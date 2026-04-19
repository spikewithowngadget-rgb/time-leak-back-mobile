import 'package:auto_route/auto_route.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/core/storage/onboarding_prefs.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    /// Календарь — начальная точка. Если гвард не пустит, сработает редирект.
    AutoRoute(page: CalendarRoute.page, initial: true, guards: [AuthGuard()]),

    /// Онбординг (первый запуск без сессии)
    AutoRoute(page: OnBoardingRoute.page),

    /// Страница логина
    AutoRoute(page: LoginRoute.page),

    AutoRoute(page: AboutRoute.page, guards: [AuthGuard()]),

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
      // Токена нет — онбординг при первом запуске, иначе логин
      final onboardingDone = await OnboardingPrefs.isCompleted();
      if (!onboardingDone) {
        await router.replaceAll([const OnBoardingRoute()]);
      } else {
        await router.replaceAll([const LoginRoute()]);
      }
      resolver.next(false);
    }
  }
}
