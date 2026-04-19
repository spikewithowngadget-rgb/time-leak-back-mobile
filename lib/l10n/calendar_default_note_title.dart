import 'package:intl/intl.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';

/// Шаблон заголовка заметки по умолчанию; дата форматируется под текущую локаль.
String calendarDefaultNoteTitle(AppLocalizations l10n, DateTime date) {
  final dateStr = DateFormat('d MMMM', l10n.localeName).format(date);
  return l10n.calendar_defaultNoteTitle(dateStr);
}
