// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

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
  String get drawer_logoutConfirmTitle => 'Esci dall\'app?';

  @override
  String get drawer_logoutConfirmBody =>
      'Dovrai accedere di nuovo con telefono e password.';

  @override
  String get drawer_logoutConfirmYes => 'Esci';

  @override
  String get drawer_logoutConfirmCancel => 'Annulla';

  @override
  String get drawer_about => 'Info sull’app';

  @override
  String get about_title => 'Informazioni';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'TimeLeak ti aiuta a salvare ciò che conta e collegarlo alla data che ti serve — foto, note vocali, documenti e altro.';

  @override
  String get about_reference => 'Riferimento: Maksa Tleshov';

  @override
  String get about_deleteAccount => 'Elimina account';

  @override
  String get about_deleteDialogTitle => 'Disattivare l’account?';

  @override
  String get about_deleteDialogBody =>
      'Il tuo account verrà disattivato. Non potrai più accedere.';

  @override
  String get about_deleteDialogConfirm => 'Disattiva';

  @override
  String get about_deleteDialogCancel => 'Annulla';

  @override
  String get about_deleteErrorNoProfile =>
      'Impossibile caricare il profilo. Riprova.';

  @override
  String get about_deleteErrorForbidden =>
      'Impossibile disattivare: accesso negato. Il server deve consentire questa azione per gli utenti autenticati—contatta l’assistenza o il tuo team backend.';

  @override
  String get onboarding_title => 'Dimenticato?';

  @override
  String get onboarding_page1_bullets =>
      '• patente scaduta => multa, riesame, rimozione\n• anniversario di matrimonio => problemi a casa';

  @override
  String get onboarding_page1_question => 'Come te lo ricordi?';

  @override
  String get onboarding_page1_conclusion => 'L\'app TimeLeak lo fa per te!';

  @override
  String get onboarding_page2_bullet =>
      '• dichiarazione dei redditi => multe per commercialista e azienda';

  @override
  String get onboarding_page2_conclusion =>
      'In TimeLeak scatta foto, video, nota vocale o scegli un documento — poi tocca la data che ti serve!';

  @override
  String get onboarding_next => 'Avanti';

  @override
  String get onboarding_skip => 'Salta';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Promemoria da TimeLeak: $date — hai una nota';
  }

  @override
  String get calendar_reminderNotificationBody => 'Hai una nota';

  @override
  String get calendar_cameraSheetTitle => 'Fotocamera';

  @override
  String get calendar_cameraPhoto => 'Scatta foto';

  @override
  String get calendar_cameraVideo => 'Registra video';

  @override
  String get calendar_selectDayFirst =>
      'Seleziona prima un giorno nel calendario';

  @override
  String get calendar_status_fileSaved => 'File salvato';

  @override
  String get calendar_status_saveError => 'Errore di salvataggio';

  @override
  String get calendar_status_fileDeleted => 'File eliminato';

  @override
  String get calendar_status_deleteError => 'Errore di eliminazione';

  @override
  String get calendar_status_fileExportedToDownloads => 'Salvato in Download';

  @override
  String get calendar_status_exportError => 'Errore di esportazione';

  @override
  String get calendar_action_onRepeat => 'In ripetizione';

  @override
  String get calendar_action_delete => 'Elimina';

  @override
  String get calendar_action_download => 'Scarica';

  @override
  String get calendar_action_remind => 'Ricorda';

  @override
  String get calendar_status_reminderSaved => 'Promemoria salvato';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Registrazione: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Promemoria';

  @override
  String get calendar_reminderDialog_afterAttachTitle => 'Ricordami';

  @override
  String get calendar_reminderDialog_current => 'Ora:';

  @override
  String get calendar_reminderDialog_changeTo => 'Cambia a';

  @override
  String get calendar_reminderDialog_yearly_title => 'Annualmente';

  @override
  String get calendar_reminderDialog_yearly_subtitle => 'Tra 365 giorni';

  @override
  String get calendar_reminderDialog_quarterly_title => 'Trimestralmente';

  @override
  String get calendar_reminderDialog_quarterly_subtitle => 'Tra 3 mesi';

  @override
  String get calendar_reminderDialog_monthly_title => 'Mensilmente';

  @override
  String get calendar_reminderDialog_monthly_subtitle => 'Tra 30 giorni';

  @override
  String get calendar_reminderDialog_customDays_title => 'Personalizzato';

  @override
  String get calendar_reminderDialog_customDays_subtitle =>
      'Inserisci il numero di giorni';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Ogni giorno';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'Tra 24 ore';

  @override
  String get calendar_reminderDialog_custom_title => 'Personalizzato';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Specifica giorni, ore o minuti';

  @override
  String get calendar_reminderDialog_unit_days => 'Giorni';

  @override
  String get calendar_reminderDialog_unit_hours => 'Ore';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minuti';

  @override
  String get calendar_reminderDialog_save => 'Salva';

  @override
  String get calendar_reminderDialog_setError =>
      'Impossibile impostare il promemoria';

  @override
  String get calendar_reminderLabel_notSet => 'Non impostato';

  @override
  String get calendar_reminderLabel_yearly => 'Annualmente';

  @override
  String get calendar_reminderLabel_quarterly => 'Trimestralmente';

  @override
  String get calendar_reminderLabel_monthly => 'Mensilmente';

  @override
  String get calendar_reminderLabel_everyDay => 'Ogni giorno';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'Tra $count g.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'Tra $count h';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'Tra $count min';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Numero di giorni';

  @override
  String get calendar_reminderDialog_hint_hours => 'Numero di ore';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Numero di minuti';

  @override
  String get calendar_reminderDialog_suffix_days => 'g';

  @override
  String get calendar_reminderDialog_suffix_hours => 'h';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'min';
}
