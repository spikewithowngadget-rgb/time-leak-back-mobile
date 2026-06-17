import 'dart:async';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';

/// Синхронизирует бейдж на иконке приложения с количеством записей календаря.
/// Считается так же, как красные бейджи на сетке: одна запись = одна «штука».
class AppIconBadgeService {
  final SyncedNotesRepository _notesRepository;

  StreamSubscription<int>? _countSubscription;

  AppIconBadgeService(this._notesRepository);

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
      final supported = await AppBadgePlus.isSupported();
      if (!supported) return;

      if (count <= 0) {
        await AppBadgePlus.updateBadge(0);
      } else {
        await AppBadgePlus.updateBadge(count);
      }
    } catch (e, st) {
      debugPrint('AppIconBadgeService badge update failed: $e\n$st');
    }
  }

  /// Сбросить бейдж (например при выходе).
  Future<void> clear() async {
    await _applyCount(0);
  }

  void dispose() {
    _countSubscription?.cancel();
    _countSubscription = null;
  }
}
