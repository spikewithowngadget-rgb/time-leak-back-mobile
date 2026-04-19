// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get drawer_about => 'Sobre o app';

  @override
  String get about_title => 'Sobre';

  @override
  String get about_versionLabel => 'Version';

  @override
  String get about_description =>
      'O TimeLeak ajuda você a guardar o que importa e vincular à data que precisa — fotos, notas de voz, documentos e muito mais.';

  @override
  String get about_deleteAccount => 'Excluir conta';

  @override
  String get about_deleteDialogTitle => 'Desativar conta?';

  @override
  String get about_deleteDialogBody =>
      'Sua conta será desativada. Você não poderá entrar novamente.';

  @override
  String get about_deleteDialogConfirm => 'Desativar';

  @override
  String get about_deleteDialogCancel => 'Cancelar';

  @override
  String get about_deleteErrorNoProfile =>
      'Não foi possível carregar seu perfil. Tente novamente.';

  @override
  String get about_deleteErrorForbidden =>
      'Não foi possível desativar: acesso negado. O servidor precisa permitir esta ação para usuários autenticados—fale com o suporte ou com sua equipe de backend.';

  @override
  String get onboarding_title => 'Esqueceu?';

  @override
  String get onboarding_page1_bullets =>
      '• carta caducada => multa, repetição, reboque\n• aniversário de casamento => problema em casa';

  @override
  String get onboarding_page1_question => 'Como se lembra?';

  @override
  String get onboarding_page1_conclusion => 'A app TimeLeak faz isso por si!';

  @override
  String get onboarding_page2_bullet =>
      '• declaração fiscal => multas para o contabilista e a empresa';

  @override
  String get onboarding_page2_conclusion =>
      'No TimeLeak tire foto, vídeo, nota de voz ou escolha um documento — depois toque na data certa!';

  @override
  String get onboarding_next => 'Seguinte';

  @override
  String get onboarding_skip => 'Saltar';

  @override
  String calendar_defaultNoteTitle(String date) {
    return 'Lembrete do TimeLeak: $date — você tem uma nota';
  }

  @override
  String get calendar_reminderNotificationBody => 'Você tem uma nota';

  @override
  String get calendar_status_fileSaved => 'Arquivo salvo';

  @override
  String get calendar_status_saveError => 'Erro ao salvar';

  @override
  String get calendar_status_fileDeleted => 'Arquivo excluído';

  @override
  String get calendar_status_deleteError => 'Erro ao excluir';

  @override
  String get calendar_status_fileExportedToDownloads => 'Salvo em Downloads';

  @override
  String get calendar_status_exportError => 'Erro ao exportar';

  @override
  String get calendar_action_onRepeat => 'Em repetição';

  @override
  String get calendar_action_delete => 'Excluir';

  @override
  String get calendar_action_download => 'Baixar';

  @override
  String get calendar_action_remind => 'Lembrar';

  @override
  String get calendar_status_reminderSaved => 'Lembrete salvo';

  @override
  String calendar_recordingStatus(String duration) {
    return 'Gravação: $duration';
  }

  @override
  String get calendar_reminderDialog_title => 'Lembrete';

  @override
  String get calendar_reminderDialog_current => 'Agora:';

  @override
  String get calendar_reminderDialog_changeTo => 'Mudar para';

  @override
  String get calendar_reminderDialog_everyDay_title => 'Todos os dias';

  @override
  String get calendar_reminderDialog_everyDay_subtitle => 'Em 24 horas';

  @override
  String get calendar_reminderDialog_custom_title => 'Personalizado';

  @override
  String get calendar_reminderDialog_custom_subtitle =>
      'Informe dias, horas ou minutos';

  @override
  String get calendar_reminderDialog_unit_days => 'Dias';

  @override
  String get calendar_reminderDialog_unit_hours => 'Horas';

  @override
  String get calendar_reminderDialog_unit_minutes => 'Minutos';

  @override
  String get calendar_reminderDialog_save => 'Salvar';

  @override
  String get calendar_reminderDialog_setError =>
      'Não foi possível definir o lembrete';

  @override
  String get calendar_reminderLabel_notSet => 'Não definido';

  @override
  String get calendar_reminderLabel_everyDay => 'Todos os dias';

  @override
  String calendar_reminderLabel_inDays(int count) {
    return 'Em $count d.';
  }

  @override
  String calendar_reminderLabel_inHours(int count) {
    return 'Em $count h';
  }

  @override
  String calendar_reminderLabel_inMinutes(int count) {
    return 'Em $count min';
  }

  @override
  String get calendar_reminderDialog_hint_days => 'Número de dias';

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
