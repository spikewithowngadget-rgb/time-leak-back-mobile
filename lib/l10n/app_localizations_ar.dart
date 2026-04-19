// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get drawer_about => 'حول التطبيق';

  @override
  String get about_title => 'حول التطبيق';

  @override
  String get about_versionLabel => 'الإصدار';

  @override
  String get about_description =>
      'يساعدك TimeLeak على حفظ ما يهمك وربطه بالتاريخ الذي تحتاجه — صور، ملاحظات صوتية، مستندات، وأكثر.';

  @override
  String get about_deleteAccount => 'حذف الحساب';

  @override
  String get about_deleteDialogTitle => 'إلغاء تفعيل الحساب؟';

  @override
  String get about_deleteDialogBody =>
      'سيتم إلغاء تفعيل حسابك. لن تتمكن من تسجيل الدخول مرة أخرى.';

  @override
  String get about_deleteDialogConfirm => 'إلغاء التفعيل';

  @override
  String get about_deleteDialogCancel => 'إلغاء';

  @override
  String get about_deleteErrorNoProfile =>
      'تعذر تحميل ملفك الشخصي. حاول مرة أخرى.';

  @override
  String get about_deleteErrorForbidden =>
      'تعذر إلغاء التفعيل: تم رفض الوصول. يجب أن يسمح الخادم بهذه العملية للمستخدمين المسجلين—تواصل مع الدعم أو فريق الباك-إند.';

  @override
  String get onboarding_title => 'نسيت؟';

  @override
  String get onboarding_page1_bullets =>
      '• انتهاء رخصة القيادة => غرامة، إعادة امتحان، ساحبة\n• ذكرى الزواج => مشاكل في البيت';

  @override
  String get onboarding_page1_question => 'كيف تذكّر نفسك؟';

  @override
  String get onboarding_page1_conclusion => 'تطبيق TimeLeak سيتولى ذلك!';

  @override
  String get onboarding_page2_bullet =>
      '• إقرار ضريبي => غرامات على المحاسب والمؤسسة';

  @override
  String get onboarding_page2_conclusion =>
      'في TimeLeak التقط صورة أو فيديو أو رسالة صوتية أو اختر مستندًا — ثم انقر التاريخ المطلوب!';

  @override
  String get onboarding_next => 'التالي';

  @override
  String get onboarding_skip => 'تخطي';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'تذكير من TimeLeak: $date — لديك ملاحظة';
  }

  @override
  String get calendar_reminderNotificationBody => 'لديك ملاحظة';

  @override
  String get calendar_status_fileSaved => 'تم حفظ الملف';

  @override
  String get calendar_status_saveError => 'فشل الحفظ';

  @override
  String get calendar_status_fileDeleted => 'تم حذف الملف';

  @override
  String get calendar_status_deleteError => 'فشل الحذف';

  @override
  String get calendar_status_fileExportedToDownloads => 'تم الحفظ في التنزيلات';

  @override
  String get calendar_status_exportError => 'فشل التصدير';

  @override
  String get calendar_action_onRepeat => 'تكرار';

  @override
  String get calendar_action_delete => 'حذف';

  @override
  String get calendar_action_download => 'تنزيل';

  @override
  String get calendar_action_remind => 'تذكير';

  @override
  String get calendar_status_reminderSaved => 'تم حفظ التذكير';

  @override
  String calendar_recordingStatus(String duration) {
    return 'تسجيل: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'تذكير';

  @override
  String get calendar_reminderDialog_current => 'الآن:';

  @override
  String get calendar_reminderDialog_changeTo => 'تغيير إلى';

  @override
  String get calendar_reminderDialog_everyDay_title => 'كل يوم';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'بعد 24 ساعة';

  @override
  String get calendar_reminderDialog_custom_title => 'مخصص';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'حدد أيامًا أو ساعات أو دقائق';

  @override
  String get calendar_reminderDialog_unit_days => 'أيام';

  @override
  String get calendar_reminderDialog_unit_hours => 'ساعات';

  @override
  String get calendar_reminderDialog_unit_minutes => 'دقائق';

  @override
  String get calendar_reminderDialog_save => 'حفظ';

  @override
  String get calendar_reminderDialog_setError => 'تعذر ضبط التذكير';

  @override
  String get calendar_reminderLabel_notSet => 'غير مضبوط';

  @override
  String get calendar_reminderLabel_everyDay => 'كل يوم';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'بعد $count يوم';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'بعد $count ساعة';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'بعد $count دقيقة';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'عدد الأيام';

  @override
  String get calendar_reminderDialog_hint_hours => 'عدد الساعات';

  @override
  String get calendar_reminderDialog_hint_minutes => 'عدد الدقائق';

  @override
  String get calendar_reminderDialog_suffix_days => 'يوم';

  @override
  String get calendar_reminderDialog_suffix_hours => 'ساعة';

  @override
  String get calendar_reminderDialog_suffix_minutes => 'دقيقة';
}
