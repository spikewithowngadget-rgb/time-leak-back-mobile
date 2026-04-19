import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @login_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get login_welcomeBack;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your TimeLeak account'**
  String get login_subtitle;

  /// No description provided for @login_phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get login_phoneLabel;

  /// No description provided for @login_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_passwordLabel;

  /// No description provided for @login_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgotPassword;

  /// No description provided for @login_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_signIn;

  /// No description provided for @pin_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get pin_screenTitle;

  /// No description provided for @pin_accessCode.
  ///
  /// In en, this message translates to:
  /// **'Access code'**
  String get pin_accessCode;

  /// No description provided for @pin_createCode.
  ///
  /// In en, this message translates to:
  /// **'Create access code'**
  String get pin_createCode;

  /// No description provided for @pin_confirmCode.
  ///
  /// In en, this message translates to:
  /// **'Confirm code'**
  String get pin_confirmCode;

  /// No description provided for @pin_wrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code'**
  String get pin_wrongCode;

  /// No description provided for @pin_codesDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Codes do not match'**
  String get pin_codesDoNotMatch;

  /// No description provided for @pin_biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app'**
  String get pin_biometricReason;

  /// No description provided for @drawer_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawer_settings;

  /// No description provided for @drawer_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawer_language;

  /// No description provided for @drawer_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get drawer_logout;

  /// No description provided for @drawer_about.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get drawer_about;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// No description provided for @about_versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_versionLabel;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'TimeLeak helps you capture what matters and tie it to the date you need — photos, voice notes, documents, and more.'**
  String get about_description;

  /// No description provided for @about_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get about_deleteAccount;

  /// No description provided for @about_deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate account?'**
  String get about_deleteDialogTitle;

  /// No description provided for @about_deleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deactivated. You will not be able to sign in again.'**
  String get about_deleteDialogBody;

  /// No description provided for @about_deleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get about_deleteDialogConfirm;

  /// No description provided for @about_deleteDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get about_deleteDialogCancel;

  /// No description provided for @about_deleteErrorNoProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile. Please try again.'**
  String get about_deleteErrorNoProfile;

  /// No description provided for @about_deleteErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Could not deactivate: access denied. The server must allow this action for logged-in users—contact support or your backend team.'**
  String get about_deleteErrorForbidden;

  /// No description provided for @onboarding_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get onboarding_title;

  /// No description provided for @onboarding_page1_bullets.
  ///
  /// In en, this message translates to:
  /// **'• driver\'s license expired => fine, retake, impound lot\n• wedding anniversary => trouble at home'**
  String get onboarding_page1_bullets;

  /// No description provided for @onboarding_page1_question.
  ///
  /// In en, this message translates to:
  /// **'How do you remind yourself?'**
  String get onboarding_page1_question;

  /// No description provided for @onboarding_page1_conclusion.
  ///
  /// In en, this message translates to:
  /// **'The TimeLeak mobile app will do it for you!'**
  String get onboarding_page1_conclusion;

  /// No description provided for @onboarding_page2_bullet.
  ///
  /// In en, this message translates to:
  /// **'• tax filing => fines for the accountant and the company'**
  String get onboarding_page2_bullet;

  /// No description provided for @onboarding_page2_conclusion.
  ///
  /// In en, this message translates to:
  /// **'In TimeLeak, just take a photo, video, or voice note, or pick a document — then tap the date you need!'**
  String get onboarding_page2_conclusion;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @calendar_defaultNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder from TimeLeak: {date} — you have a note'**
  String calendar_defaultNoteTitle(String date);

  /// No description provided for @calendar_reminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'You have a note'**
  String get calendar_reminderNotificationBody;

  /// No description provided for @calendar_status_fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get calendar_status_fileSaved;

  /// No description provided for @calendar_status_saveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get calendar_status_saveError;

  /// No description provided for @calendar_status_fileDeleted.
  ///
  /// In en, this message translates to:
  /// **'File deleted'**
  String get calendar_status_fileDeleted;

  /// No description provided for @calendar_status_deleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get calendar_status_deleteError;

  /// No description provided for @calendar_status_fileExportedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads'**
  String get calendar_status_fileExportedToDownloads;

  /// No description provided for @calendar_status_exportError.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get calendar_status_exportError;

  /// No description provided for @calendar_action_onRepeat.
  ///
  /// In en, this message translates to:
  /// **'On repeat'**
  String get calendar_action_onRepeat;

  /// No description provided for @calendar_action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get calendar_action_delete;

  /// No description provided for @calendar_action_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get calendar_action_download;

  /// No description provided for @calendar_action_remind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get calendar_action_remind;

  /// No description provided for @calendar_status_reminderSaved.
  ///
  /// In en, this message translates to:
  /// **'Reminder saved'**
  String get calendar_status_reminderSaved;

  /// No description provided for @calendar_recordingStatus.
  ///
  /// In en, this message translates to:
  /// **'Recording: {duration}'**
  String calendar_recordingStatus(String duration);

  /// No description provided for @calendar_reminderDialog_title.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get calendar_reminderDialog_title;

  /// No description provided for @calendar_reminderDialog_current.
  ///
  /// In en, this message translates to:
  /// **'Now:'**
  String get calendar_reminderDialog_current;

  /// No description provided for @calendar_reminderDialog_changeTo.
  ///
  /// In en, this message translates to:
  /// **'Change to'**
  String get calendar_reminderDialog_changeTo;

  /// No description provided for @calendar_reminderDialog_everyDay_title.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get calendar_reminderDialog_everyDay_title;

  /// No description provided for @calendar_reminderDialog_everyDay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'In 24 hours'**
  String get calendar_reminderDialog_everyDay_subtitle;

  /// No description provided for @calendar_reminderDialog_custom_title.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get calendar_reminderDialog_custom_title;

  /// No description provided for @calendar_reminderDialog_custom_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Specify days, hours, or minutes'**
  String get calendar_reminderDialog_custom_subtitle;

  /// No description provided for @calendar_reminderDialog_unit_days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get calendar_reminderDialog_unit_days;

  /// No description provided for @calendar_reminderDialog_unit_hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get calendar_reminderDialog_unit_hours;

  /// No description provided for @calendar_reminderDialog_unit_minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get calendar_reminderDialog_unit_minutes;

  /// No description provided for @calendar_reminderDialog_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get calendar_reminderDialog_save;

  /// No description provided for @calendar_reminderDialog_setError.
  ///
  /// In en, this message translates to:
  /// **'Could not set reminder'**
  String get calendar_reminderDialog_setError;

  /// No description provided for @calendar_reminderLabel_notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get calendar_reminderLabel_notSet;

  /// No description provided for @calendar_reminderLabel_everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get calendar_reminderLabel_everyDay;

  /// No description provided for @calendar_reminderLabel_inDays.
  ///
  /// In en, this message translates to:
  /// **'In {count} d.'**
  String calendar_reminderLabel_inDays(int count);

  /// No description provided for @calendar_reminderLabel_inHours.
  ///
  /// In en, this message translates to:
  /// **'In {count} h.'**
  String calendar_reminderLabel_inHours(int count);

  /// No description provided for @calendar_reminderLabel_inMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {count} min.'**
  String calendar_reminderLabel_inMinutes(int count);

  /// No description provided for @calendar_reminderDialog_hint_days.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get calendar_reminderDialog_hint_days;

  /// No description provided for @calendar_reminderDialog_hint_hours.
  ///
  /// In en, this message translates to:
  /// **'Number of hours'**
  String get calendar_reminderDialog_hint_hours;

  /// No description provided for @calendar_reminderDialog_hint_minutes.
  ///
  /// In en, this message translates to:
  /// **'Number of minutes'**
  String get calendar_reminderDialog_hint_minutes;

  /// No description provided for @calendar_reminderDialog_suffix_days.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get calendar_reminderDialog_suffix_days;

  /// No description provided for @calendar_reminderDialog_suffix_hours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get calendar_reminderDialog_suffix_hours;

  /// No description provided for @calendar_reminderDialog_suffix_minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get calendar_reminderDialog_suffix_minutes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
