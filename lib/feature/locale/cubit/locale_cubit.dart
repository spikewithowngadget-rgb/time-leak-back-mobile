import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppLanguage {
  english('en'),
  russian('ru'),
  chinese('zh'),
  hindi('hi'),
  french('fr'),
  german('de'),
  spanish('es'),
  italian('it'),
  portuguese('pt'),
  arabic('ar');

  final String code;
  const AppLanguage(this.code);
}

class LocaleCubit extends Cubit<Locale> {
  // По умолчанию английский через enum
  LocaleCubit() : super(Locale(AppLanguage.english.code));

  void changeLanguage(AppLanguage language) {
    emit(Locale(language.code));
  }
}

/// Короткий код для компактных кнопок (онбординг, чипы).
extension AppLanguageChipCode on AppLanguage {
  String get chipCode => switch (this) {
    AppLanguage.english => 'EN',
    AppLanguage.russian => 'RU',
    AppLanguage.chinese => 'ZH',
    AppLanguage.hindi => 'HI',
    AppLanguage.french => 'FR',
    AppLanguage.german => 'DE',
    AppLanguage.spanish => 'ES',
    AppLanguage.italian => 'IT',
    AppLanguage.portuguese => 'PT',
    AppLanguage.arabic => 'AR',
  };
}

extension AppLanguageLabel on AppLanguage {
  /// Короткое название языка для списка в UI.
  String get label => switch (this) {
    AppLanguage.english => 'English',
    AppLanguage.russian => 'Русский',
    AppLanguage.chinese => '中文',
    AppLanguage.hindi => 'हिन्दी',
    AppLanguage.french => 'Français',
    AppLanguage.german => 'Deutsch',
    AppLanguage.spanish => 'Español',
    AppLanguage.italian => 'Italiano',
    AppLanguage.portuguese => 'Português',
    AppLanguage.arabic => 'العربية',
  };
}
