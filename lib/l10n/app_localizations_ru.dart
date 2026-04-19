// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login_welcomeBack => 'Добро пожаловать';

  @override
  String get login_subtitle => 'Войдите в свой аккаунт TimeLeak';

  @override
  String get login_phoneLabel => 'Телефон';

  @override
  String get login_passwordLabel => 'Пароль';

  @override
  String get login_forgotPassword => 'Забыли пароль?';

  @override
  String get login_signIn => 'Войти';

  @override
  String get pin_screenTitle => 'Авторизация';

  @override
  String get pin_accessCode => 'Код доступа';

  @override
  String get pin_createCode => 'Придумайте код доступа';

  @override
  String get pin_confirmCode => 'Повторите код';

  @override
  String get pin_wrongCode => 'Неверный код';

  @override
  String get pin_codesDoNotMatch => 'Коды не совпадают';

  @override
  String get pin_biometricReason => 'Разблокируйте приложение';

  @override
  String get drawer_settings => 'Настройки';

  @override
  String get drawer_language => 'Язык';

  @override
  String get drawer_logout => 'Выйти';

  @override
  String get drawer_about => 'О приложении';

  @override
  String get about_title => 'О приложении';

  @override
  String get about_versionLabel => 'Версия';

  @override
  String get about_description =>
      'TimeLeak помогает фиксировать важное и привязывать к нужной дате: фото, голос, документы и другое.';

  @override
  String get about_deleteAccount => 'Удалить аккаунт';

  @override
  String get about_deleteDialogTitle => 'Деактивировать аккаунт?';

  @override
  String get about_deleteDialogBody =>
      'Аккаунт будет деактивирован. Войти снова будет нельзя.';

  @override
  String get about_deleteDialogConfirm => 'Деактивировать';

  @override
  String get about_deleteDialogCancel => 'Отмена';

  @override
  String get about_deleteErrorNoProfile =>
      'Не удалось загрузить профиль. Попробуйте позже.';

  @override
  String get about_deleteErrorForbidden =>
      'Не удалось деактивировать: доступ запрещён (403). На сервере нужно разрешить этот запрос для пользовательского JWT или выдать отдельный эндпоинт — обратитесь к команде бэкенда.';

  @override
  String get onboarding_title => 'Забыли';

  @override
  String get onboarding_page1_bullets =>
      '• истекли вод. права => штраф, пересдача, штрафстоянка\n• годовщина свадьбы => жена обидится';

  @override
  String get onboarding_page1_question => 'Как напомнить себе про это?';

  @override
  String get onboarding_page1_conclusion =>
      'Мобильное приложение TimeLeak сделает это!';

  @override
  String get onboarding_page2_bullet =>
      '• отчет в налоговую => штраф на бухгалтера и организацию';

  @override
  String get onboarding_page2_conclusion =>
      'В Таймлик просто сделав фото или видео или аудиосообщение или выбрав документ кликните по нужной дате!';

  @override
  String get onboarding_next => 'Далее';

  @override
  String get onboarding_skip => 'Пропустить';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Напоминание от TimeLeak: $date у вас заметка';
  }

  @override
  String get calendar_reminderNotificationBody => 'У вас заметка';

  @override
  String get calendar_status_fileSaved => 'Файл успешно сохранен';

  @override
  String get calendar_status_saveError => 'Ошибка при сохранении';

  @override
  String get calendar_status_fileDeleted => 'Файл удален';

  @override
  String get calendar_status_deleteError => 'Ошибка при удалении';

  @override
  String get calendar_status_fileExportedToDownloads =>
      'Файл сохранен в Загрузки';

  @override
  String get calendar_status_exportError => 'Ошибка при экспорте';

  @override
  String get calendar_action_onRepeat => 'На Повторе';

  @override
  String get calendar_action_delete => 'Удалить';

  @override
  String get calendar_action_download => 'Скачать';

  @override
  String get calendar_action_remind => 'Напомнить';

  @override
  String get calendar_status_reminderSaved => 'Напоминание сохранено';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Запись: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Напоминание';

  @override
  String get calendar_reminderDialog_current => 'Сейчас:';

  @override
  String get calendar_reminderDialog_changeTo => 'Изменить на';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Каждый день';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'Через 24 часа';

  @override
  String get calendar_reminderDialog_custom_title => 'Свой вариант';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Укажите дни, часы или минуты';

  @override
  String get calendar_reminderDialog_unit_days => 'Дни';

  @override
  String get calendar_reminderDialog_unit_hours => 'Часы';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Минуты';

  @override
  String get calendar_reminderDialog_save => 'Сохранить';

  @override
  String get calendar_reminderDialog_setError =>
      'Ошибка при установке напоминания';

  @override
  String get calendar_reminderLabel_notSet => 'Не задано';

  @override
  String get calendar_reminderLabel_everyDay => 'Каждый день';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'Через $count д.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'Через $count ч.';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'Через $count мин.';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Число дней';

  @override
  String get calendar_reminderDialog_hint_hours => 'Число часов';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Число минут';

  @override
  String get calendar_reminderDialog_suffix_days => 'дн.';

  @override
  String get calendar_reminderDialog_suffix_hours => 'ч.';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'мин.';
}
