import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const int androidBadgeNotificationId = 999999;
  static const String androidBadgeChannelId = 'app_badge_channel_v3';
  static const String androidNotesChannelId = 'notes_channel';

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final SyncedNotesRepository _syncedNotesRepository;

  NotificationService(this._syncedNotesRepository);

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      'ic_notification',
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

    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        androidBadgeChannelId,
        'App badge',
        description: 'Shows reminder count on the app icon',
        importance: Importance.high,
        showBadge: true,
      ),
    );

    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        androidNotesChannelId,
        'Notes Notifications',
        description: 'Уведомления для заметок',
        importance: Importance.max,
        showBadge: true,
      ),
    );
  }

  /// Запрос разрешений после готовности Activity (не из main до runApp).
  Future<bool> ensureAndroidNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return false;

    var enabled = await androidImpl.areNotificationsEnabled() ?? false;
    if (!enabled) {
      enabled = await androidImpl.requestNotificationsPermission() ?? false;
    }

    try {
      await androidImpl.requestExactAlarmsPermission();
    } catch (e, st) {
      debugPrint('requestExactAlarmsPermission: $e\n$st');
    }

    return enabled;
  }

  /// Показать число напоминаний на иконке через активное уведомление + number.
  Future<void> updateAndroidIconBadge(int count) async {
    if (!Platform.isAndroid) return;
    if (!await ensureAndroidNotificationsEnabled()) {
      debugPrint('updateAndroidIconBadge: notifications disabled');
      return;
    }

    if (count <= 0) {
      await _notifications.cancel(id: androidBadgeNotificationId);
      return;
    }

    await _notifications.show(
      id: androidBadgeNotificationId,
      title: 'TimeLeak',
      body: count == 1 ? '1 note' : '$count notes',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidBadgeChannelId,
          'App badge',
          channelDescription: 'Shows reminder count on the app icon',
          icon: 'ic_notification',
          importance: Importance.high,
          priority: Priority.high,
          number: count,
          channelShowBadge: true,
          showWhen: false,
          onlyAlertOnce: true,
          autoCancel: false,
          ongoing: true,
          category: AndroidNotificationCategory.reminder,
          visibility: NotificationVisibility.public,
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
    if (Platform.isAndroid) {
      await ensureAndroidNotificationsEnabled();
    }

    final details = const NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotesChannelId,
        'Notes Notifications',
        channelDescription: 'Уведомления для заметок',
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true,
        category: AndroidNotificationCategory.reminder,
      ),
    );

    final when = tz.TZDateTime.from(scheduledDate, tz.local);
    try {
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: when,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, st) {
      debugPrint('exact schedule failed, fallback inexact: $e\n$st');
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: when,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> scheduleFlexibleNotification({
    required int id,
    required String title,
    required String body,
    required int totalMinutes,
  }) async {
    if (Platform.isAndroid) {
      await ensureAndroidNotificationsEnabled();
    }

    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(minutes: totalMinutes));
    final details = const NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotesChannelId,
        'Notes Notifications',
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true,
        category: AndroidNotificationCategory.reminder,
      ),
    );

    try {
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, st) {
      debugPrint('exact schedule failed, fallback inexact: $e\n$st');
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> updateNotificationTime({
    required int id,
    required String title,
    required String body,
    required DateTime newScheduledDate,
  }) async {
    await _notifications.cancel(id: id);
    await scheduleNotification(id: id, title: title, body: body, scheduledDate: newScheduledDate);
  }

  SyncedNotesRepository get syncedNotesRepository => _syncedNotesRepository;
}
