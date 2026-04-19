// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get login_welcomeBack => 'Welcome Back';

  @override
  String get login_subtitle => 'Sign in to your TimeLeak account';

  @override
  String get login_phoneLabel => 'Phone';

  @override
  String get login_passwordLabel => 'Password';

  @override
  String get login_forgotPassword => 'Forgot password?';

  @override
  String get login_signIn => 'Sign in';

  @override
  String get pin_screenTitle => 'Authorization';

  @override
  String get pin_accessCode => 'Access code';

  @override
  String get pin_createCode => 'Create access code';

  @override
  String get pin_confirmCode => 'Confirm code';

  @override
  String get pin_wrongCode => 'Wrong code';

  @override
  String get pin_codesDoNotMatch => 'Codes do not match';

  @override
  String get pin_biometricReason => 'Unlock the app';

  @override
  String get drawer_settings => 'Settings';

  @override
  String get drawer_language => 'Language';

  @override
  String get drawer_logout => 'Log out';

  @override
  String get drawer_about => 'Acerca de la app';

  @override
  String get about_title => 'Acerca de';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'TimeLeak te ayuda a guardar lo importante y vincularlo a la fecha que necesitas — fotos, notas de voz, documentos y más.';

  @override
  String get about_deleteAccount => 'Eliminar cuenta';

  @override
  String get about_deleteDialogTitle => '¿Desactivar cuenta?';

  @override
  String get about_deleteDialogBody =>
      'Tu cuenta se desactivará. No podrás volver a iniciar sesión.';

  @override
  String get about_deleteDialogConfirm => 'Desactivar';

  @override
  String get about_deleteDialogCancel => 'Cancelar';

  @override
  String get about_deleteErrorNoProfile =>
      'No se pudo cargar tu perfil. Inténtalo de nuevo.';

  @override
  String get about_deleteErrorForbidden =>
      'No se pudo desactivar: acceso denegado. El servidor debe permitir esta acción para usuarios con sesión iniciada—contacta con soporte o con tu equipo backend.';

  @override
  String get onboarding_title => '¿Olvidaste?';

  @override
  String get onboarding_page1_bullets =>
      '• carnet caducado => multa, examen, depósito\n• aniversario de boda => problema en casa';

  @override
  String get onboarding_page1_question => '¿Cómo te lo recuerdas?';

  @override
  String get onboarding_page1_conclusion => '¡La app TimeLeak lo hace por ti!';

  @override
  String get onboarding_page2_bullet =>
      '• declaración de impuestos => multas al gestor y a la empresa';

  @override
  String get onboarding_page2_conclusion =>
      'En TimeLeak haz una foto, video, nota de voz o elige un documento — ¡y toca la fecha que necesitas!';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get onboarding_skip => 'Omitir';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Recordatorio de TimeLeak: $date — tienes una nota';
  }

  @override
  String get calendar_reminderNotificationBody => 'Tienes una nota';

  @override
  String get calendar_status_fileSaved => 'Archivo guardado';

  @override
  String get calendar_status_saveError => 'Error al guardar';

  @override
  String get calendar_status_fileDeleted => 'Archivo eliminado';

  @override
  String get calendar_status_deleteError => 'Error al eliminar';

  @override
  String get calendar_status_fileExportedToDownloads => 'Guardado en Descargas';

  @override
  String get calendar_status_exportError => 'Error al exportar';

  @override
  String get calendar_action_onRepeat => 'En repetición';

  @override
  String get calendar_action_delete => 'Eliminar';

  @override
  String get calendar_action_download => 'Descargar';

  @override
  String get calendar_action_remind => 'Recordar';

  @override
  String get calendar_status_reminderSaved => 'Recordatorio guardado';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Grabación: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Recordatorio';

  @override
  String get calendar_reminderDialog_current => 'Ahora:';

  @override
  String get calendar_reminderDialog_changeTo => 'Cambiar a';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Cada día';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'En 24 horas';

  @override
  String get calendar_reminderDialog_custom_title => 'Personalizado';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Indica días, horas o minutos';

  @override
  String get calendar_reminderDialog_unit_days => 'Días';

  @override
  String get calendar_reminderDialog_unit_hours => 'Horas';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minutos';

  @override
  String get calendar_reminderDialog_save => 'Guardar';

  @override
  String get calendar_reminderDialog_setError =>
      'No se pudo configurar el recordatorio';

  @override
  String get calendar_reminderLabel_notSet => 'No establecido';

  @override
  String get calendar_reminderLabel_everyDay => 'Cada día';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'En $count d.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'En $count h.';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'En $count min.';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Número de días';

  @override
  String get calendar_reminderDialog_hint_hours => 'Número de horas';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Número de minutos';

  @override
  String get calendar_reminderDialog_suffix_days => 'd';

  @override
  String get calendar_reminderDialog_suffix_hours => 'h';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'min';
}
