// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get drawer_about => 'About the app';

  @override
  String get about_title => 'About';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'TimeLeak helps you capture what matters and tie it to the date you need — photos, voice notes, documents, and more.';

  @override
  String get about_deleteAccount => 'Delete account';

  @override
  String get about_deleteDialogTitle => 'Deactivate account?';

  @override
  String get about_deleteDialogBody =>
      'Your account will be deactivated. You will not be able to sign in again.';

  @override
  String get about_deleteDialogConfirm => 'Deactivate';

  @override
  String get about_deleteDialogCancel => 'Cancel';

  @override
  String get about_deleteErrorNoProfile =>
      'Could not load your profile. Please try again.';

  @override
  String get about_deleteErrorForbidden =>
      'Could not deactivate: access denied. The server must allow this action for logged-in users—contact support or your backend team.';

  @override
  String get onboarding_title => 'Forgot?';

  @override
  String get onboarding_page1_bullets =>
      '• driver\'s license expired => fine, retake, impound lot\n• wedding anniversary => trouble at home';

  @override
  String get onboarding_page1_question => 'How do you remind yourself?';

  @override
  String get onboarding_page1_conclusion =>
      'The TimeLeak mobile app will do it for you!';

  @override
  String get onboarding_page2_bullet =>
      '• tax filing => fines for the accountant and the company';

  @override
  String get onboarding_page2_conclusion =>
      'In TimeLeak, just take a photo, video, or voice note, or pick a document — then tap the date you need!';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Reminder from TimeLeak: $date — you have a note';
  }

  @override
  String get calendar_reminderNotificationBody => 'You have a note';

  @override
  String get calendar_status_fileSaved => 'File saved';

  @override
  String get calendar_status_saveError => 'Save failed';

  @override
  String get calendar_status_fileDeleted => 'File deleted';

  @override
  String get calendar_status_deleteError => 'Delete failed';

  @override
  String get calendar_status_fileExportedToDownloads => 'Saved to Downloads';

  @override
  String get calendar_status_exportError => 'Export failed';

  @override
  String get calendar_action_onRepeat => 'On repeat';

  @override
  String get calendar_action_delete => 'Delete';

  @override
  String get calendar_action_download => 'Download';

  @override
  String get calendar_action_remind => 'Remind';

  @override
  String get calendar_status_reminderSaved => 'Reminder saved';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Recording: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Reminder';

  @override
  String get calendar_reminderDialog_current => 'Now:';

  @override
  String get calendar_reminderDialog_changeTo => 'Change to';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Every day';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'In 24 hours';

  @override
  String get calendar_reminderDialog_custom_title => 'Custom';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Specify days, hours, or minutes';

  @override
  String get calendar_reminderDialog_unit_days => 'Days';

  @override
  String get calendar_reminderDialog_unit_hours => 'Hours';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minutes';

  @override
  String get calendar_reminderDialog_save => 'Save';

  @override
  String get calendar_reminderDialog_setError => 'Could not set reminder';

  @override
  String get calendar_reminderLabel_notSet => 'Not set';

  @override
  String get calendar_reminderLabel_everyDay => 'Every day';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'In $count d.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'In $count h.';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'In $count min.';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Number of days';

  @override
  String get calendar_reminderDialog_hint_hours => 'Number of hours';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Number of minutes';

  @override
  String get calendar_reminderDialog_suffix_days => 'd';

  @override
  String get calendar_reminderDialog_suffix_hours => 'h';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'min';
}
