import 'dart:async';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';

/// Синхронизирует бейдж на иконке с числом записей календаря
/// (сегодня и дальше: локальные + пришедшие с бэка при синке).
class AppIconBadgeService {
  final SyncedNotesRepository _notesRepository;
  final NotificationService _notificationService;

  StreamSubscription<int>? _countSubscription;
  int _lastCount = 0;

  AppIconBadgeService(this._notesRepository, this._notificationService);

  /// Подписаться на изменения и обновлять бейдж.
  /// Вызывать после готовности UI (не из main до первого кадра).
  Future<void> start() async {
    await _countSubscription?.cancel();

    if (Platform.isAndroid) {
      await _notificationService.ensureAndroidNotificationsEnabled();
    }

    _countSubscription = _notesRepository.watchUpcomingEntriesCount().listen(
      _applyCount,
      onError: (Object e, StackTrace st) {
        debugPrint('AppIconBadgeService: $e\n$st');
      },
    );
  }

  /// Заново прочитать счётчик из БД и применить (после синка / permission).
  Future<void> refresh() async {
    if (Platform.isAndroid) {
      await _notificationService.ensureAndroidNotificationsEnabled();
    }
    final count = await _notesRepository.watchUpcomingEntriesCount().first;
    await _applyCount(count);
  }

  Future<void> _applyCount(int count) async {
    _lastCount = count;
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        await AppBadgePlus.updateBadge(count <= 0 ? 0 : count);
        return;
      }

      if (!Platform.isAndroid) return;

      await _notificationService.updateAndroidIconBadge(count);

      try {
        if (await AppBadgePlus.isSupported()) {
          await AppBadgePlus.updateBadge(count <= 0 ? 0 : count);
        }
      } catch (e, st) {
        debugPrint('AppBadgePlus update failed: $e\n$st');
      }
    } catch (e, st) {
      debugPrint('AppIconBadgeService badge update failed: $e\n$st');
    }
  }

  Future<void> clear() async {
    await _countSubscription?.cancel();
    _countSubscription = null;
    _lastCount = 0;
    await _applyCount(0);
  }

  void dispose() {
    _countSubscription?.cancel();
    _countSubscription = null;
  }
}
