// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

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
  String get drawer_about => 'À propos de l’app';

  @override
  String get about_title => 'À propos';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'TimeLeak vous aide à capturer l’essentiel et à l’associer à la date voulue — photos, notes vocales, documents, et plus encore.';

  @override
  String get about_deleteAccount => 'Supprimer le compte';

  @override
  String get about_deleteDialogTitle => 'Désactiver le compte ?';

  @override
  String get about_deleteDialogBody =>
      'Votre compte sera désactivé. Vous ne pourrez plus vous connecter.';

  @override
  String get about_deleteDialogConfirm => 'Désactiver';

  @override
  String get about_deleteDialogCancel => 'Annuler';

  @override
  String get about_deleteErrorNoProfile =>
      'Impossible de charger votre profil. Veuillez réessayer.';

  @override
  String get about_deleteErrorForbidden =>
      'Impossible de désactiver : accès refusé. Le serveur doit autoriser cette action pour les utilisateurs connectés — contactez le support ou votre équipe backend.';

  @override
  String get onboarding_title => 'Oublié ?';

  @override
  String get onboarding_page1_bullets =>
      '• permis expiré => amende, repasser, fourrière\n• anniversaire de mariage => problème à la maison';

  @override
  String get onboarding_page1_question => 'Comment vous le rappeler ?';

  @override
  String get onboarding_page1_conclusion =>
      'L\'application TimeLeak s\'en charge pour vous !';

  @override
  String get onboarding_page2_bullet =>
      '• déclaration fiscale => amendes pour le comptable et l\'entreprise';

  @override
  String get onboarding_page2_conclusion =>
      'Dans TimeLeak, prenez une photo, une vidéo, un vocal ou choisissez un document — puis touchez la date souhaitée !';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_skip => 'Passer';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Rappel de TimeLeak : $date — vous avez une note';
  }

  @override
  String get calendar_reminderNotificationBody => 'Vous avez une note';

  @override
  String get calendar_status_fileSaved => 'Fichier enregistré';

  @override
  String get calendar_status_saveError => 'Échec de l’enregistrement';

  @override
  String get calendar_status_fileDeleted => 'Fichier supprimé';

  @override
  String get calendar_status_deleteError => 'Échec de la suppression';

  @override
  String get calendar_status_fileExportedToDownloads =>
      'Enregistré dans Téléchargements';

  @override
  String get calendar_status_exportError => 'Échec de l’export';

  @override
  String get calendar_action_onRepeat => 'En répétition';

  @override
  String get calendar_action_delete => 'Supprimer';

  @override
  String get calendar_action_download => 'Télécharger';

  @override
  String get calendar_action_remind => 'Rappeler';

  @override
  String get calendar_status_reminderSaved => 'Rappel enregistré';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Enregistrement : $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Rappel';

  @override
  String get calendar_reminderDialog_current => 'Maintenant :';

  @override
  String get calendar_reminderDialog_changeTo => 'Changer pour';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Chaque jour';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'Dans 24 heures';

  @override
  String get calendar_reminderDialog_custom_title => 'Personnalisé';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Indiquez jours, heures ou minutes';

  @override
  String get calendar_reminderDialog_unit_days => 'Jours';

  @override
  String get calendar_reminderDialog_unit_hours => 'Heures';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minutes';

  @override
  String get calendar_reminderDialog_save => 'Enregistrer';

  @override
  String get calendar_reminderDialog_setError =>
      'Impossible de définir le rappel';

  @override
  String get calendar_reminderLabel_notSet => 'Non défini';

  @override
  String get calendar_reminderLabel_everyDay => 'Chaque jour';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'Dans $count j.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'Dans $count h';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'Dans $count min';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Nombre de jours';

  @override
  String get calendar_reminderDialog_hint_hours => 'Nombre d’heures';

  @override
  String get calendar_reminderDialog_hint_minutes => 'Nombre de minutes';

  @override
  String get calendar_reminderDialog_suffix_days => 'j';

  @override
  String get calendar_reminderDialog_suffix_hours => 'h';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'min';
}
