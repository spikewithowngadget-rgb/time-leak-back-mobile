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
  String get login_noAccount => 'No account? ';

  @override
  String get login_registerLink => 'Sign up';

  @override
  String get register_title => 'Registration';

  @override
  String get register_phoneSubtitle =>
      'Enter your phone number to receive a verification code';

  @override
  String get register_phoneLabel => 'Phone number';

  @override
  String get register_getCode => 'Get code';

  @override
  String get register_errorEnterPhone => 'Enter your phone number';

  @override
  String get register_verifyTitle => 'Verification';

  @override
  String register_verifySubtitle(String phone) {
    return 'We sent a code to $phone';
  }

  @override
  String get register_smsCodeLabel => 'SMS code';

  @override
  String get register_resendCode => 'Resend code';

  @override
  String get register_confirm => 'Confirm';

  @override
  String get register_errorEnterFullCode => 'Enter the full code';

  @override
  String get register_passwordTitle => 'Create a password';

  @override
  String get register_passwordSubtitle =>
      'Use at least 8 characters for a strong password';

  @override
  String get register_confirmPasswordLabel => 'Confirm password';

  @override
  String get register_complete => 'Complete registration';

  @override
  String get register_success => 'Registration successful!';

  @override
  String get register_errorFillAllFields => 'Fill in all fields';

  @override
  String get register_errorPasswordsMismatch => 'Passwords do not match';

  @override
  String get register_errorPasswordTooShort => 'Password is too short';

  @override
  String get reset_title => 'Password recovery';

  @override
  String get reset_subtitle =>
      'Enter your phone number to receive an access code';

  @override
  String get reset_sendCode => 'Send code';

  @override
  String get reset_verifyTitle => 'Verification code';

  @override
  String reset_verifySubtitle(String phone) {
    return 'We sent it to\n$phone';
  }

  @override
  String get reset_resendCode => 'Send again';

  @override
  String get reset_continue => 'Continue';

  @override
  String get reset_newPasswordTitle => 'New password';

  @override
  String get reset_newPasswordSubtitle =>
      'Create a new password for your account';

  @override
  String get reset_passwordHint => 'Password';

  @override
  String get reset_confirmPasswordHint => 'Repeat password';

  @override
  String get reset_updatePassword => 'Update password';

  @override
  String get reset_success => 'Password changed successfully!';

  @override
  String get reset_errorFillAllFields => 'Fill in all fields';

  @override
  String get reset_errorPasswordsMismatch => 'Passwords do not match';

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
  String get drawer_logoutConfirmTitle => 'Sign out?';

  @override
  String get drawer_logoutConfirmBody =>
      'You will need to sign in with your phone and password again.';

  @override
  String get drawer_logoutConfirmYes => 'Sign out';

  @override
  String get drawer_logoutConfirmCancel => 'Cancel';

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
  String get about_reference => 'Reference: Maksa Tleshov';

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
  String get calendar_cameraSheetTitle => 'Camera';

  @override
  String get calendar_cameraPhoto => 'Take photo';

  @override
  String get calendar_cameraVideo => 'Record video';

  @override
  String get calendar_selectDayFirst => 'Select a day on the calendar first';

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
  String get calendar_reminderDialog_afterAttachTitle => 'Remind me';

  @override
  String get calendar_reminderDialog_current => 'Ahora:';

  @override
  String get calendar_reminderDialog_changeTo => 'Cambiar a';

  @override
  String get calendar_reminderDialog_yearly_title => 'Annually';

  @override
  String get calendar_reminderDialog_yearly_subtitle => 'In 365 days';

  @override
  String get calendar_reminderDialog_quarterly_title => 'Quarterly';

  @override
  String get calendar_reminderDialog_quarterly_subtitle => 'In 3 months';

  @override
  String get calendar_reminderDialog_monthly_title => 'Monthly';

  @override
  String get calendar_reminderDialog_monthly_subtitle => 'In 30 days';

  @override
  String get calendar_reminderDialog_customDays_title => 'Custom';

  @override
  String get calendar_reminderDialog_customDays_subtitle =>
      'Enter number of days';

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
  String get calendar_reminderLabel_yearly => 'Annually';

  @override
  String get calendar_reminderLabel_quarterly => 'Quarterly';

  @override
  String get calendar_reminderLabel_monthly => 'Monthly';

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
