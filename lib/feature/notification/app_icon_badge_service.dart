import 'dart:async';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';

/// Синхронизирует бейдж на иконке приложения с количеством записей календаря.
/// Считается так же, как красные бейджи на сетке: одна запись = одна «штука».
class AppIconBadgeService {
  final SyncedNotesRepository _notesRepository;
  final NotificationService _notificationService;

  StreamSubscription<int>? _countSubscription;

  AppIconBadgeService(this._notesRepository, this._notificationService);

  /// Подписаться на изменения в локальной БД и обновлять бейдж.
  Future<void> start() async {
    await _countSubscription?.cancel();
    _countSubscription = _notesRepository.watchEntriesCount().listen(
      _applyCount,
      onError: (Object e, StackTrace st) {
        debugPrint('AppIconBadgeService: $e\n$st');
      },
    );
  }

  Future<void> _applyCount(int count) async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        await AppBadgePlus.updateBadge(count <= 0 ? 0 : count);
        return;
      }

      if (!Platform.isAndroid) return;

      final launcherSupportsBadge = await AppBadgePlus.isSupported();
      if (launcherSupportsBadge) {
        await AppBadgePlus.updateBadge(count <= 0 ? 0 : count);
        if (count <= 0) {
          await _notificationService.updateAndroidIconBadge(0);
        }
        return;
      }

      // Pixel / stock Android: badge via silent notification with number.
      await _notificationService.updateAndroidIconBadge(count);
    } catch (e, st) {
      debugPrint('AppIconBadgeService badge update failed: $e\n$st');
    }
  }

  /// Сбросить бейдж и отписаться от счётчика (например при выходе).
  Future<void> clear() async {
    await _countSubscription?.cancel();
    _countSubscription = null;
    await _applyCount(0);
  }

  void dispose() {
    _countSubscription?.cancel();
    _countSubscription = null;
  }
}
