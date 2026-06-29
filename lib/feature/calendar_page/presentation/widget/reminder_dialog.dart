import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/reminder_day_wheel.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';
import 'package:time_leak_flutter/l10n/calendar_default_note_title.dart';

const int yearlyReminderMinutes = 365 * 24 * 60;
const int quarterlyReminderMinutes = 91 * 24 * 60;
const int monthlyReminderMinutes = 30 * 24 * 60;
const int everyDayReminderMinutes = 24 * 60;

int reminderMinutesFromDays(int days) => days * 24 * 60;

/// Форматирует текущее значение напоминания для отображения.
String formatReminderLabel(BuildContext context, int? minutes) {
  final l10n = context.l10n;
  if (minutes == null || minutes <= 0) return l10n.calendar_reminderLabel_notSet;
  if (minutes == everyDayReminderMinutes) return l10n.calendar_reminderLabel_everyDay;
  if (minutes == yearlyReminderMinutes) return l10n.calendar_reminderLabel_yearly;
  if (minutes == quarterlyReminderMinutes) return l10n.calendar_reminderLabel_quarterly;
  if (minutes == monthlyReminderMinutes) return l10n.calendar_reminderLabel_monthly;
  if (minutes >= 24 * 60) return l10n.calendar_reminderLabel_inDays(minutes ~/ (24 * 60));
  if (minutes >= 60) return l10n.calendar_reminderLabel_inHours(minutes ~/ 60);
  return l10n.calendar_reminderLabel_inMinutes(minutes);
}

class ReminderDialog extends StatefulWidget {
  final CalendarEntryModel? entry;
  final DateTime? date;
  final int? initialMinutes;
  final VoidCallback? onSaved;
  final ValueChanged<int>? onMinutesSelected;
  final bool afterAttach;

  const ReminderDialog({
    super.key,
    this.entry,
    this.date,
    this.initialMinutes,
    this.onSaved,
    this.onMinutesSelected,
    this.afterAttach = false,
  }) : assert(entry != null || date != null, 'Either entry or date must be provided');

  static Future<void> show(
    BuildContext context, {
    required CalendarEntryModel entry,
    VoidCallback? onSaved,
    bool afterAttach = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: afterAttach,
      builder: (context) => ReminderDialog(entry: entry, onSaved: onSaved, afterAttach: afterAttach),
    );
  }

  static Future<void> showForDate(
    BuildContext context, {
    required DateTime date,
    int? initialMinutes,
    required ValueChanged<int> onMinutesSelected,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReminderDialog(
        date: date,
        initialMinutes: initialMinutes,
        onMinutesSelected: onMinutesSelected,
        afterAttach: true,
      ),
    );
  }

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  bool _saving = false;
  late int _selectedDays;
  late final TextEditingController _daysController;
  bool _syncingFromWheel = false;

  @override
  void initState() {
    super.initState();
    final current = widget.entry?.reminderMinutes ?? widget.initialMinutes;
    if (current != null && current >= 24 * 60) {
      _selectedDays = current ~/ (24 * 60);
    } else {
      _selectedDays = 1;
    }
    _daysController = TextEditingController(text: '$_selectedDays');
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  void _onWheelChanged(int days) {
    if (_syncingFromWheel) return;
    _syncingFromWheel = true;
    setState(() => _selectedDays = days);
    _daysController.text = '$days';
    _daysController.selection = TextSelection.collapsed(offset: _daysController.text.length);
    _syncingFromWheel = false;
  }

  void _onCustomDaysChanged(String value) {
    if (_syncingFromWheel) return;
    final days = int.tryParse(value.trim());
    if (days == null || days <= 0) return;
    setState(() => _selectedDays = days);
  }

  Future<void> _applyMinutes(int totalMinutes) async {
    if (totalMinutes <= 0 || _saving) return;

    if (widget.entry == null) {
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onMinutesSelected?.call(totalMinutes);
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final notificationService = sl<NotificationService>();
      final repo = sl<SyncedNotesRepository>();
      final entry = widget.entry!;
      final l10n = context.l10n;
      final notificationTitle = entry.title?.trim().isNotEmpty == true
          ? entry.title!
          : calendarDefaultNoteTitle(l10n, entry.date);

      await notificationService.scheduleFlexibleNotification(
        id: entry.id,
        title: notificationTitle,
        body: l10n.calendar_reminderNotificationBody,
        totalMinutes: totalMinutes,
      );
      await repo.updateReminder(entry.id, totalMinutes);

      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSaved?.call();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('ReminderDialog save error: $e');
        debugPrint(st.toString());
      }
      if (mounted) {
        TopSnackBar.show(
          context,
          message: context.l10n.calendar_reminderDialog_setError,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _onConfirm() {
    _applyMinutes(reminderMinutesFromDays(_selectedDays));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDateMode = widget.entry == null;
    final currentLabel = formatReminderLabel(context, widget.entry?.reminderMinutes ?? widget.initialMinutes);
    final title = isDateMode || widget.afterAttach
        ? l10n.calendar_reminderDialog_afterAttachTitle
        : l10n.calendar_reminderDialog_title;

    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.widthByContext(20))),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: context.widthByContext(20),
          right: context.widthByContext(20),
          top: context.heightByContext(20),
          bottom: context.heightByContext(20) + context.bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStyle.style(
                      context.widthByContext(20),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.grey2),
                  style: IconButton.styleFrom(backgroundColor: Colors.transparent),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (!widget.afterAttach && !isDateMode) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.brandColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: AppColors.black.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.calendar_reminderDialog_current} ',
                      style: AppStyle.style(13, color: AppColors.grey2),
                    ),
                    Expanded(
                      child: Text(
                        currentLabel,
                        style: AppStyle.style(13, fontWeight: FontWeight.w600, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ] else
              const SizedBox(height: 4),
            if (_saving)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.buttonColor),
                  ),
                ),
              )
            else ...[
              ReminderDayWheel(
                selectedDays: _selectedDays.clamp(reminderMinDays, reminderMaxDays),
                onChanged: _onWheelChanged,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                onChanged: _onCustomDaysChanged,
                style: AppStyle.style(15, color: AppColors.black),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.calendar_reminderDialog_hint_days,
                  hintStyle: AppStyle.style(13, color: AppColors.grey2),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixText: l10n.calendar_reminderDialog_suffix_days,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: _saving ? null : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.calendar_reminderDialog_save,
                    style: AppStyle.style(15, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
