/// Разблокировка календаря в рамках сессии приложения (до выхода или сброса токена).
class PinSession {
  PinSession._();

  static bool _calendarUnlocked = false;

  static bool get calendarUnlocked => _calendarUnlocked;

  static void unlock() {
    _calendarUnlocked = true;
  }

  static void reset() {
    _calendarUnlocked = false;
  }

  /// Блокировка календаря без сброса сохранённого PIN (неактивность / фон).
  static void lock() {
    _calendarUnlocked = false;
  }
}
