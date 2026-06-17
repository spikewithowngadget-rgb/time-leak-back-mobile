import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/l10n/calendar_default_note_title.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';

const int yearlyReminderMinutes = 365 * 24 * 60;
const int quarterlyReminderMinutes = 91 * 24 * 60;
const int monthlyReminderMinutes = 30 * 24 * 60;
const int everyDayReminderMinutes = 24 * 60;

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
  final CalendarEntryModel entry;
  final VoidCallback? onSaved;
  final bool afterAttach;

  const ReminderDialog({
    super.key,
    required this.entry,
    this.onSaved,
    this.afterAttach = false,
  });

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

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  late String _selectedOption; // yearly | quarterly | monthly | custom
  final TextEditingController _customDaysController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = 'monthly';
    final current = widget.entry.reminderMinutes;
    if (current != null) {
      if (current == yearlyReminderMinutes) {
        _selectedOption = 'yearly';
      } else if (current == quarterlyReminderMinutes) {
        _selectedOption = 'quarterly';
      } else if (current == monthlyReminderMinutes) {
        _selectedOption = 'monthly';
      } else if (current >= 24 * 60) {
        _selectedOption = 'custom';
        _customDaysController.text = '${current ~/ (24 * 60)}';
      }
    }
  }

  @override
  void dispose() {
    _customDaysController.dispose();
    super.dispose();
  }

  int _computeTotalMinutes() {
    switch (_selectedOption) {
      case 'yearly':
        return yearlyReminderMinutes;
      case 'quarterly':
        return quarterlyReminderMinutes;
      case 'monthly':
        return monthlyReminderMinutes;
      default:
        final days = int.tryParse(_customDaysController.text) ?? 0;
        return days * 24 * 60;
    }
  }

  Future<void> _save() async {
    final totalMinutes = _computeTotalMinutes();
    if (_selectedOption == 'custom' && totalMinutes <= 0) return;

    setState(() => _saving = true);
    try {
      final notificationService = sl<NotificationService>();
      final repo = sl<SyncedNotesRepository>();

      final l10n = context.l10n;
      final notificationTitle = widget.entry.title?.trim().isNotEmpty == true
          ? widget.entry.title!
          : calendarDefaultNoteTitle(l10n, widget.entry.date);

      await notificationService.scheduleFlexibleNotification(
        id: widget.entry.id,
        title: notificationTitle,
        body: l10n.calendar_reminderNotificationBody,
        totalMinutes: totalMinutes,
      );
      await repo.updateReminder(widget.entry.id, totalMinutes);

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLabel = formatReminderLabel(context, widget.entry.reminderMinutes);
    final title = widget.afterAttach ? l10n.calendar_reminderDialog_afterAttachTitle : l10n.calendar_reminderDialog_title;

    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
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
                    style: AppStyle.style(22, fontWeight: FontWeight.w700, color: AppColors.black),
                  ),
                ),
                IconButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.grey2),
                  style: IconButton.styleFrom(backgroundColor: Colors.transparent),
                ),
              ],
            ),
            if (!widget.afterAttach) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.brandColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 20, color: AppColors.black.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Text(
                      '${l10n.calendar_reminderDialog_current} ',
                      style: AppStyle.style(14, color: AppColors.grey2),
                    ),
                    Expanded(
                      child: Text(
                        currentLabel,
                        style: AppStyle.style(14, fontWeight: FontWeight.w600, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.calendar_reminderDialog_changeTo,
                style: AppStyle.style(14, color: AppColors.grey2),
              ),
              const SizedBox(height: 12),
            ] else
              const SizedBox(height: 8),
            _OptionTile(
              title: l10n.calendar_reminderDialog_yearly_title,
              subtitle: l10n.calendar_reminderDialog_yearly_subtitle,
              isSelected: _selectedOption == 'yearly',
              onTap: () => setState(() => _selectedOption = 'yearly'),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              title: l10n.calendar_reminderDialog_quarterly_title,
              subtitle: l10n.calendar_reminderDialog_quarterly_subtitle,
              isSelected: _selectedOption == 'quarterly',
              onTap: () => setState(() => _selectedOption = 'quarterly'),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              title: l10n.calendar_reminderDialog_monthly_title,
              subtitle: l10n.calendar_reminderDialog_monthly_subtitle,
              isSelected: _selectedOption == 'monthly',
              onTap: () => setState(() => _selectedOption = 'monthly'),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              title: l10n.calendar_reminderDialog_customDays_title,
              subtitle: l10n.calendar_reminderDialog_customDays_subtitle,
              isSelected: _selectedOption == 'custom',
              onTap: () => setState(() => _selectedOption = 'custom'),
            ),
            if (_selectedOption == 'custom') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _customDaysController,
                keyboardType: TextInputType.number,
                style: AppStyle.style(16, color: AppColors.black),
                decoration: InputDecoration(
                  hintText: l10n.calendar_reminderDialog_hint_days,
                  hintStyle: AppStyle.style(14, color: AppColors.grey2),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixText: l10n.calendar_reminderDialog_suffix_days,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black),
                      )
                    : Text(
                        l10n.calendar_reminderDialog_save,
                        style: AppStyle.style(16, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandColor2.withValues(alpha: 0.3) : AppColors.brandColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.buttonColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyle.style(16, fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppStyle.style(12, color: AppColors.grey2),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.buttonColor : AppColors.grey1,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
