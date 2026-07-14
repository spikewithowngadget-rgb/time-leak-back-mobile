import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const int androidBadgeNotificationId = 999999;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final SyncedNotesRepository _syncedNotesRepository;

  NotificationService(this._syncedNotesRepository);

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings: settings);

    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'app_badge_channel',
        'App badge',
        description: 'Shows note count on the app icon',
        importance: Importance.low,
        showBadge: true,
      ),
    );
  }

  Future<bool> ensureAndroidNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return false;
    if (await androidImpl.areNotificationsEnabled() ?? false) return true;
    return await androidImpl.requestNotificationsPermission() ?? false;
  }

  /// Stock Android launchers (Pixel etc.) show icon badges via active notifications.
  Future<void> updateAndroidIconBadge(int count) async {
    if (!Platform.isAndroid) return;
    if (!await ensureAndroidNotificationsEnabled()) return;

    if (count <= 0) {
      await _notifications.cancel(id: androidBadgeNotificationId);
      return;
    }

    await _notifications.show(
      id: androidBadgeNotificationId,
      title: 'TimeLeak',
      body: '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'app_badge_channel',
          'App badge',
          channelDescription: 'Shows note count on the app icon',
          importance: Importance.low,
          priority: Priority.low,
          number: count,
          channelShowBadge: true,
          showWhen: false,
          onlyAlertOnce: true,
          silent: true,
          ongoing: true,
          autoCancel: false,
          visibility: NotificationVisibility.secret,
        ),
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // ВАЖНО: Все аргументы теперь передаются строго по именам
    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'notes_channel',
          'Notes Notifications',
          channelDescription: 'Уведомления для заметок',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleFlexibleNotification({
    required int id,
    required String title,
    required String body,
    required int totalMinutes, // Передаем итоговое время в минутах из твоего диалога
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(minutes: totalMinutes));

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'notes_channel',
          'Notes Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Отменить запланированное уведомление по id.
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  /// Обновить время показа уведомления (отменить старое и запланировать на новое время).
  Future<void> updateNotificationTime({
    required int id,
    required String title,
    required String body,
    required DateTime newScheduledDate,
  }) async {
    await _notifications.cancel(id: id);
    await scheduleNotification(id: id, title: title, body: body, scheduledDate: newScheduledDate);
  }

  /// Доступ к репозиторию (для синхронизации уведомлений с записями).
  SyncedNotesRepository get syncedNotesRepository => _syncedNotesRepository;
}
