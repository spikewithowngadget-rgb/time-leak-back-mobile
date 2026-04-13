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
