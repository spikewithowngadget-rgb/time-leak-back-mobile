import 'package:get_it/get_it.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/core/service/dio.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/core/storage/base_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/calendar_repository.dart';
import 'package:time_leak_flutter/feature/ads/data/repository/ads_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/core/data/repository/notes_repository.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';
import 'package:time_leak_flutter/feature/login/data/repository/auth_repository.dart';
import 'package:time_leak_flutter/feature/login/presentation/cubit/login_cubit.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';
import 'package:time_leak_flutter/feature/register/presentation/cubit/register_cubit.dart';
import 'package:time_leak_flutter/feature/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:time_leak_flutter/feature/user/cubit/user_cubit.dart';
import 'package:time_leak_flutter/feature/user/data/repository/user_repository.dart';

final sl = GetIt.instance;
void setupLocator() {
  sl.registerSingleton<AppRouter>(AppRouter());
  // 1. База данных
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // 2. DioClient (Регистрируем первым, он теперь не требует зависимостей в конструкторе)
  sl.registerSingleton<DioClient>(DioClient(sl<AppDatabase>()));

  sl.registerLazySingleton<BaseRepository<CalendarEntries, CalendarEntry>>(
    () => BaseRepository(sl<AppDatabase>(), sl<AppDatabase>().calendarEntries),
  );
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepository(sl<BaseRepository<CalendarEntries, CalendarEntry>>(), sl<AppDatabase>()),
  );
  sl.registerLazySingleton<NotesRepository>(() => NotesRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<SyncedNotesRepository>(
    () => SyncedNotesRepository(sl<CalendarRepository>(), sl<NotesRepository>()),
  );
  sl.registerLazySingleton<AdsRepository>(() => AdsRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<DioClient>().dio, sl<AppDatabase>()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl<DioClient>().dio));
  // 4. Cubits
  sl.registerLazySingleton(() => LocaleCubit());
  sl.registerFactory(() => LoginCubit(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterCubit(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UserCubit(sl<UserRepository>()));
  sl.registerLazySingleton(() => ResetPasswordCubit(sl<AuthRepository>()));
  sl.registerLazySingleton(() => NotificationService(sl<SyncedNotesRepository>()));
}
