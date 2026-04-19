// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
  String get drawer_about => '关于应用';

  @override
  String get about_title => '关于应用';

  @override
  String get about_versionLabel => '版本';

  @override
  String get about_description => 'TimeLeak 帮助你记录重要内容并绑定到指定日期——照片、语音笔记、文档等。';

  @override
  String get about_deleteAccount => '删除账号';

  @override
  String get about_deleteDialogTitle => '停用账号？';

  @override
  String get about_deleteDialogBody => '你的账号将被停用，之后将无法再次登录。';

  @override
  String get about_deleteDialogConfirm => '停用';

  @override
  String get about_deleteDialogCancel => '取消';

  @override
  String get about_deleteErrorNoProfile => '无法加载你的资料。请重试。';

  @override
  String get about_deleteErrorForbidden =>
      '无法停用：访问被拒绝。服务器必须允许已登录用户执行此操作——请联系支持或后端团队。';

  @override
  String get onboarding_title => '忘了吗？';

  @override
  String get onboarding_page1_bullets =>
      '• 驾照过期 => 罚款、重考、扣车场\n• 结婚纪念日 => 家里不高兴';

  @override
  String get onboarding_page1_question => '怎么提醒自己？';

  @override
  String get onboarding_page1_conclusion => 'TimeLeak 移动应用来帮你！';

  @override
  String get onboarding_page2_bullet => '• 报税 => 对会计和公司的罚款';

  @override
  String get onboarding_page2_conclusion =>
      '在 TimeLeak 中拍照、录像、语音或选择文件，然后点击对应日期即可！';

  @override
  String get onboarding_next => '下一步';

  @override
  String get onboarding_skip => '跳过';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'TimeLeak 提醒：$date，您有一条笔记';
  }

  @override
  String get calendar_reminderNotificationBody => '您有一条笔记';

  @override
  String get calendar_status_fileSaved => '文件已保存';

  @override
  String get calendar_status_saveError => '保存失败';

  @override
  String get calendar_status_fileDeleted => '文件已删除';

  @override
  String get calendar_status_deleteError => '删除失败';

  @override
  String get calendar_status_fileExportedToDownloads => '已保存到下载';

  @override
  String get calendar_status_exportError => '导出失败';

  @override
  String get calendar_action_onRepeat => '重复';

  @override
  String get calendar_action_delete => '删除';

  @override
  String get calendar_action_download => '下载';

  @override
  String get calendar_action_remind => '提醒';

  @override
  String get calendar_status_reminderSaved => '提醒已保存';

  @override
  String calendar_recordingStatus(String duration) {
    return '录音：$duration';
  }

  @override
  String get calendar_reminderDialog_title => '提醒';

  @override
  String get calendar_reminderDialog_current => '当前：';

  @override
  String get calendar_reminderDialog_changeTo => '更改为';

  @override
  String get calendar_reminderDialog_everyDay_title => '每天';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => '24 小时后';

  @override
  String get calendar_reminderDialog_custom_title => '自定义';

  @override
  String get calendar_reminderDialog_custom_subtitle => '设置天、小时或分钟';

  @override
  String get calendar_reminderDialog_unit_days => '天';

  @override
  String get calendar_reminderDialog_unit_hours => '小时';

  @override
  String get calendar_reminderDialog_unit_minutes => '分钟';

  @override
  String get calendar_reminderDialog_save => '保存';

  @override
  String get calendar_reminderDialog_setError => '无法设置提醒';

  @override
  String get calendar_reminderLabel_notSet => '未设置';

  @override
  String get calendar_reminderLabel_everyDay => '每天';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return '$count 天后';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return '$count 小时后';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return '$count 分钟后';
  }

  @override
  String get calendar_reminderDialog_hint_days => '天数';

  @override
  String get calendar_reminderDialog_hint_hours => '小时数';

  @override
  String get calendar_reminderDialog_hint_minutes => '分钟数';

  @override
  String get calendar_reminderDialog_suffix_days => '天';

  @override
  String get calendar_reminderDialog_suffix_hours => '小时';

  @override
  String get calendar_reminderDialog_suffix_minutes => '分钟';
}
