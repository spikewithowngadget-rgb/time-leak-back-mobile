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
  String get login_noAccount => 'Нет аккаунта? ';

  @override
  String get login_registerLink => 'Зарегистрироваться';

  @override
  String get register_title => 'Регистрация';

  @override
  String get register_phoneSubtitle =>
      'Введите ваш номер телефона для получения кода подтверждения';

  @override
  String get register_phoneLabel => 'Номер телефона';

  @override
  String get register_getCode => 'Получить код';

  @override
  String get register_errorEnterPhone => 'Введите номер телефона';

  @override
  String get register_verifyTitle => 'Подтверждение';

  @override
  String register_verifySubtitle(String phone) {
    return 'Мы отправили код на номер $phone';
  }

  @override
  String get register_smsCodeLabel => 'Код из СМС';

  @override
  String get register_resendCode => 'Отправить код повторно';

  @override
  String get register_confirm => 'Подтвердить';

  @override
  String get register_errorEnterFullCode => 'Введите полный код';

  @override
  String get register_passwordTitle => 'Придумайте пароль';

  @override
  String get register_passwordSubtitle =>
      'Пароль должен быть надежным и содержать не менее 8 символов';

  @override
  String get register_confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get register_complete => 'Завершить регистрацию';

  @override
  String get register_success => 'Регистрация прошла успешно!';

  @override
  String get register_errorFillAllFields => 'Заполните все поля';

  @override
  String get register_errorPasswordsMismatch => 'Пароли не совпадают';

  @override
  String get register_errorPasswordTooShort => 'Пароль слишком короткий';

  @override
  String get reset_title => 'Восстановление';

  @override
  String get reset_subtitle =>
      'Введите номер телефона, чтобы получить код доступа';

  @override
  String get reset_sendCode => 'Отправить код';

  @override
  String get reset_verifyTitle => 'Код подтверждения';

  @override
  String reset_verifySubtitle(String phone) {
    return 'Мы отправили его на номер\n$phone';
  }

  @override
  String get reset_resendCode => 'Отправить еще раз';

  @override
  String get reset_continue => 'Продолжить';

  @override
  String get reset_newPasswordTitle => 'Новый пароль';

  @override
  String get reset_newPasswordSubtitle =>
      'Создайте новый пароль для доступа к вашему аккаунту';

  @override
  String get reset_passwordHint => 'Пароль';

  @override
  String get reset_confirmPasswordHint => 'Повторите пароль';

  @override
  String get reset_updatePassword => 'Обновить пароль';

  @override
  String get reset_success => 'Пароль успешно изменен!';

  @override
  String get reset_errorFillAllFields => 'Заполните все поля';

  @override
  String get reset_errorPasswordsMismatch => 'Пароли не совпадают';

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
  String get drawer_logoutConfirmTitle => 'Выйти из приложения?';

  @override
  String get drawer_logoutConfirmBody =>
      'Потребуется снова ввести телефон и пароль при следующем входе.';

  @override
  String get drawer_logoutConfirmYes => 'Выйти';

  @override
  String get drawer_logoutConfirmCancel => 'Отмена';

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
  String get about_reference => 'Референс: Maksa Tleshov';

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
  String get calendar_cameraSheetTitle => 'Камера';

  @override
  String get calendar_cameraPhoto => 'Сделать фото';

  @override
  String get calendar_cameraVideo => 'Снять видео';

  @override
  String get calendar_selectDayFirst => 'Сначала выберите день в календаре';

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
  String get calendar_reminderDialog_afterAttachTitle => 'Напоминать';

  @override
  String get calendar_reminderDialog_current => 'Сейчас:';

  @override
  String get calendar_reminderDialog_changeTo => 'Изменить на';

  @override
  String get calendar_reminderDialog_yearly_title => 'Ежегодно';

  @override
  String get calendar_reminderDialog_yearly_subtitle => 'Через 365 дней';

  @override
  String get calendar_reminderDialog_quarterly_title => 'Ежеквартально';

  @override
  String get calendar_reminderDialog_quarterly_subtitle => 'Через 3 месяца';

  @override
  String get calendar_reminderDialog_monthly_title => 'Ежемесячно';

  @override
  String get calendar_reminderDialog_monthly_subtitle => 'Через 30 дней';

  @override
  String get calendar_reminderDialog_customDays_title => 'Мой выбор';

  @override
  String get calendar_reminderDialog_customDays_subtitle =>
      'Укажите число дней';

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
  String get calendar_reminderLabel_yearly => 'Ежегодно';

  @override
  String get calendar_reminderLabel_quarterly => 'Ежеквартально';

  @override
  String get calendar_reminderLabel_monthly => 'Ежемесячно';

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
