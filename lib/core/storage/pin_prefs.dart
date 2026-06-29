import 'package:shared_preferences/shared_preferences.dart';

/// Настройки PIN-экрана календаря.
///
/// По требованию UX: PIN вводится один раз и больше не показывается
/// во время использования приложения (даже после перезапуска).
class PinPrefs {
  PinPrefs._();

  static const _unlockedOnceKey = 'calendar_pin_unlocked_once_v1';

  static Future<bool> isUnlockedOnce() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_unlockedOnceKey) ?? false;
  }

  static Future<void> setUnlockedOnce() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_unlockedOnceKey, true);
  }
}

