// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
  String get drawer_about => 'Über die App';

  @override
  String get about_title => 'Über die App';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'TimeLeak hilft dir, Wichtiges festzuhalten und an das gewünschte Datum zu binden – Fotos, Sprachnotizen, Dokumente und mehr.';

  @override
  String get about_deleteAccount => 'Konto löschen';

  @override
  String get about_deleteDialogTitle => 'Konto deaktivieren?';

  @override
  String get about_deleteDialogBody =>
      'Dein Konto wird deaktiviert. Danach kannst du dich nicht mehr anmelden.';

  @override
  String get about_deleteDialogConfirm => 'Deaktivieren';

  @override
  String get about_deleteDialogCancel => 'Abbrechen';

  @override
  String get about_deleteErrorNoProfile =>
      'Profil konnte nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get about_deleteErrorForbidden =>
      'Deaktivierung fehlgeschlagen: Zugriff verweigert. Der Server muss diese Aktion für angemeldete Nutzer erlauben – wende dich an den Support oder euer Backend-Team.';

  @override
  String get onboarding_title => 'Vergessen?';

  @override
  String get onboarding_page1_bullets =>
      '• abgelaufener Führerschein => Bußgeld, Nachprüfung, Abschleppplatz\n• Hochzeitstag => Ärger zu Hause';

  @override
  String get onboarding_page1_question => 'Wie erinnern Sie sich?';

  @override
  String get onboarding_page1_conclusion =>
      'Die TimeLeak-App macht das für Sie!';

  @override
  String get onboarding_page2_bullet =>
      '• Steuererklärung => Bußgelder für Buchhalter und Unternehmen';

  @override
  String get onboarding_page2_conclusion =>
      'In TimeLeak einfach Foto, Video, Sprachnachricht aufnehmen oder ein Dokument wählen — dann das passende Datum antippen!';

  @override
  String get onboarding_next => 'Weiter';

  @override
  String get onboarding_skip => 'Überspringen';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Erinnerung von TimeLeak: $date — Sie haben eine Notiz';
  }

  @override
  String get calendar_reminderNotificationBody => 'Sie haben eine Notiz';

  @override
  String get calendar_status_fileSaved => 'Datei gespeichert';

  @override
  String get calendar_status_saveError => 'Speichern fehlgeschlagen';

  @override
  String get calendar_status_fileDeleted => 'Datei gelöscht';

  @override
  String get calendar_status_deleteError => 'Löschen fehlgeschlagen';

  @override
  String get calendar_status_fileExportedToDownloads =>
      'In Downloads gespeichert';

  @override
  String get calendar_status_exportError => 'Export fehlgeschlagen';

  @override
  String get calendar_action_onRepeat => 'Wiederholen';

  @override
  String get calendar_action_delete => 'Löschen';

  @override
  String get calendar_action_download => 'Herunterladen';

  @override
  String get calendar_action_remind => 'Erinnern';

  @override
  String get calendar_status_reminderSaved => 'Erinnerung gespeichert';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Aufnahme: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Erinnerung';

  @override
  String get calendar_reminderDialog_current => 'Jetzt:';

  @override
  String get calendar_reminderDialog_changeTo => 'Ändern zu';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Jeden Tag';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'In 24 Stunden';

  @override
  String get calendar_reminderDialog_custom_title => 'Benutzerdefiniert';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Tage, Stunden oder Minuten angeben';

  @override
  String get calendar_reminderDialog_unit_days => 'Tage';

  @override
  String get calendar_reminderDialog_unit_hours => 'Stunden';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minuten';

  @override
  String get calendar_reminderDialog_save => 'Speichern';

  @override
  String get calendar_reminderDialog_setError =>
      'Erinnerung konnte nicht gesetzt werden';

  @override
  String get calendar_reminderLabel_notSet => 'Nicht gesetzt';

  @override
  String get calendar_reminderLabel_everyDay => 'Jeden Tag';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'In $count T.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'In $count Std.';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'In $count Min.';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Anzahl der Tage';

  @override
  String get calendar_reminderDialog_hint_hours => 'Anzahl der Stunden';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Anzahl der Minuten';

  @override
  String get calendar_reminderDialog_suffix_days => 'T';

  @override
  String get calendar_reminderDialog_suffix_hours => 'Std';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'Min';
}
