import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';
import 'package:time_leak_flutter/feature/notification/app_icon_badge_service.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';

// 4)сразу ввод цифр готовые чипы сделать

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await sl<NotificationService>().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<AppIconBadgeService>().start();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      sl<AppIconBadgeService>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = sl<AppRouter>();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<LocaleCubit>())],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'TimeLeak',
            theme: ThemeData(fontFamily: 'Arial'),
            routerConfig: appRouter.config(),
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLanguage.values.map((lang) => Locale(lang.code)).toList(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
