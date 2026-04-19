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
}
