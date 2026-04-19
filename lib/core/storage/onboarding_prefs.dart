import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  OnboardingPrefs._();

  static const _key = 'onboarding_completed_v1';

  static Future<bool> isCompleted() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_key) ?? false;
  }

  static Future<void> setCompleted() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_key, true);
  }
}
