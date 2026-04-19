// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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
  String get drawer_about => 'ऐप के बारे में';

  @override
  String get about_title => 'ऐप के बारे में';

  @override
  String get about_versionLabel => 'संस्करण';

  @override
  String get about_description =>
      'TimeLeak आपको ज़रूरी चीज़ें सहेजने और उन्हें आपकी मनचाही तारीख़ से जोड़ने में मदद करता है — फ़ोटो, वॉइस नोट्स, दस्तावेज़ और बहुत कुछ।';

  @override
  String get about_deleteAccount => 'खाता हटाएँ';

  @override
  String get about_deleteDialogTitle => 'खाता निष्क्रिय करें?';

  @override
  String get about_deleteDialogBody =>
      'आपका खाता निष्क्रिय कर दिया जाएगा। आप फिर से साइन इन नहीं कर पाएँगे।';

  @override
  String get about_deleteDialogConfirm => 'निष्क्रिय करें';

  @override
  String get about_deleteDialogCancel => 'रद्द करें';

  @override
  String get about_deleteErrorNoProfile =>
      'आपका प्रोफ़ाइल लोड नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get about_deleteErrorForbidden =>
      'निष्क्रिय नहीं किया जा सका: अनुमति नहीं है। सर्वर को लॉग-इन उपयोगकर्ताओं के लिए यह कार्रवाई अनुमति देनी होगी—सपोर्ट या अपनी बैकएंड टीम से संपर्क करें।';

  @override
  String get onboarding_title => 'भूल गए?';

  @override
  String get onboarding_page1_bullets =>
      '• ड्राइविंग लाइसेंस खत्म => जुर्माना, पुनः परीक्षा, वाहन जब्त\n• शादी की सालगिरह => घर पर समस्या';

  @override
  String get onboarding_page1_question => 'खुद को कैसे याद दिलाएँ?';

  @override
  String get onboarding_page1_conclusion => 'TimeLeak ऐप यह आपके लिए करेगा!';

  @override
  String get onboarding_page2_bullet =>
      '• टैक्स रिपोर्ट => लेखाकार और संगठन पर जुर्माना';

  @override
  String get onboarding_page2_conclusion =>
      'TimeLeak में फोटो, वीडियो, वॉइस या दस्तावेज़ चुनें — फिर सही तारीख पर टैप करें!';

  @override
  String get onboarding_next => 'आगे';

  @override
  String get onboarding_skip => 'छोड़ें';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'TimeLeak अनुस्मारक: $date — आपके पास एक नोट है';
  }

  @override
  String get calendar_reminderNotificationBody => 'आपके पास एक नोट है';

  @override
  String get calendar_status_fileSaved => 'फ़ाइल सहेजी गई';

  @override
  String get calendar_status_saveError => 'सहेजने में त्रुटि';

  @override
  String get calendar_status_fileDeleted => 'फ़ाइल हटाई गई';

  @override
  String get calendar_status_deleteError => 'हटाने में त्रुटि';

  @override
  String get calendar_status_fileExportedToDownloads => 'डाउनलोड में सहेजा गया';

  @override
  String get calendar_status_exportError => 'निर्यात में त्रुटि';

  @override
  String get calendar_action_onRepeat => 'दोहराव';

  @override
  String get calendar_action_delete => 'हटाएँ';

  @override
  String get calendar_action_download => 'डाउनलोड';

  @override
  String get calendar_action_remind => 'याद दिलाएँ';

  @override
  String get calendar_status_reminderSaved => 'अनुस्मारक सहेजा गया';

  @override
  String calendar_recordingStatus(String duration) {
    return 'रिकॉर्डिंग: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'अनुस्मारक';

  @override
  String get calendar_reminderDialog_current => 'अभी:';

  @override
  String get calendar_reminderDialog_changeTo => 'बदलें';

  @override
  String get calendar_reminderDialog_everyDay_title => 'हर दिन';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => '24 घंटे में';

  @override
  String get calendar_reminderDialog_custom_title => 'कस्टम';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'दिन, घंटे या मिनट बताएं';

  @override
  String get calendar_reminderDialog_unit_days => 'दिन';

  @override
  String get calendar_reminderDialog_unit_hours => 'घंटे';

  @override
  String get calendar_reminderDialog_unit_minutes => 'मिनट';

  @override
  String get calendar_reminderDialog_save => 'सहेजें';

  @override
  String get calendar_reminderDialog_setError => 'अनुस्मारक सेट नहीं हो सका';

  @override
  String get calendar_reminderLabel_notSet => 'सेट नहीं';

  @override
  String get calendar_reminderLabel_everyDay => 'हर दिन';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return '$count दिन में';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return '$count घंटे में';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return '$count मिनट में';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'दिनों की संख्या';

  @override
  String get calendar_reminderDialog_hint_hours => 'घंटों की संख्या';

  @override
  String get calendar_reminderDialog_hint_minutes => 'मिनटों की संख्या';

  @override
  String get calendar_reminderDialog_suffix_days => 'दिन';

  @override
  String get calendar_reminderDialog_suffix_hours => 'घं';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'मि';
}
