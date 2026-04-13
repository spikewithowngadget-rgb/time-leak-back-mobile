import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/calendar_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';

/// Форматирует текущее значение напоминания для отображения.
String formatReminderLabel(int? minutes) {
  if (minutes == null || minutes <= 0) return 'Не задано';
  if (minutes == 24 * 60) return 'Каждый день';
  if (minutes >= 24 * 60) return 'Через ${minutes ~/ (24 * 60)} д.';
  if (minutes >= 60) return 'Через ${minutes ~/ 60} ч.';
  return 'Через $minutes мин.';
}

const int _everyDayMinutes = 24 * 60; // 1440

class ReminderDialog extends StatefulWidget {
  final CalendarEntryModel entry;
  final VoidCallback? onSaved;

  const ReminderDialog({
    super.key,
    required this.entry,
    this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required CalendarEntryModel entry,
    VoidCallback? onSaved,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ReminderDialog(entry: entry, onSaved: onSaved),
    );
  }

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  late String _selectedOption; // 'every_day' | 'custom'
  late String _customUnit; // 'days' | 'hours' | 'minutes'
  final TextEditingController _customController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = 'every_day';
    _customUnit = 'hours';
    final current = widget.entry.reminderMinutes;
    if (current != null && current != _everyDayMinutes) {
      _selectedOption = 'custom';
      if (current >= 24 * 60) {
        _customUnit = 'days';
        _customController.text = '${current ~/ (24 * 60)}';
      } else if (current >= 60) {
        _customUnit = 'hours';
        _customController.text = '${current ~/ 60}';
      } else {
        _customUnit = 'minutes';
        _customController.text = '$current';
      }
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  int _computeTotalMinutes() {
    if (_selectedOption == 'every_day') return _everyDayMinutes;
    final val = int.tryParse(_customController.text) ?? 0;
    switch (_customUnit) {
      case 'days':
        return val * 24 * 60;
      case 'hours':
        return val * 60;
      default:
        return val;
    }
  }

  Future<void> _save() async {
    final totalMinutes = _computeTotalMinutes();
    if (_selectedOption == 'custom' && totalMinutes <= 0) return;

    setState(() => _saving = true);
    try {
      final notificationService = sl<NotificationService>();
      final repo = sl<SyncedNotesRepository>();

      final notificationTitle = widget.entry.title?.trim().isNotEmpty == true
          ? widget.entry.title!
          : SyncedNotesRepository.defaultTitleFor(widget.entry.date);

      await notificationService.scheduleFlexibleNotification(
        id: widget.entry.id,
        title: notificationTitle,
        body: 'У вас заметка',
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
          message: 'Ошибка при установке напоминания',
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLabel = formatReminderLabel(widget.entry.reminderMinutes);

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
                Text(
                  'Напоминание',
                  style: AppStyle.style(22, fontWeight: FontWeight.w700, color: AppColors.black),
                ),
                IconButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.grey2),
                  style: IconButton.styleFrom(backgroundColor: Colors.transparent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.brandColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 20, color: AppColors.black.withOpacity(0.7)),
                  const SizedBox(width: 10),
                  Text(
                    'Сейчас: ',
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
              'Изменить на',
              style: AppStyle.style(14, color: AppColors.grey2),
            ),
            const SizedBox(height: 12),
            _OptionTile(
              title: 'Каждый день',
              subtitle: 'Через 24 часа',
              isSelected: _selectedOption == 'every_day',
              onTap: () => setState(() => _selectedOption = 'every_day'),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              title: 'Свой вариант',
              subtitle: 'Укажите дни, часы или минуты',
              isSelected: _selectedOption == 'custom',
              onTap: () => setState(() => _selectedOption = 'custom'),
            ),
            if (_selectedOption == 'custom') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  _UnitChip(
                  label: 'Дни',
                  selected: _customUnit == 'days',
                  onTap: () => setState(() => _customUnit = 'days'),
                ),
                  const SizedBox(width: 8),
                  _UnitChip(
                    label: 'Часы',
                    selected: _customUnit == 'hours',
                    onTap: () => setState(() => _customUnit = 'hours'),
                  ),
                  const SizedBox(width: 8),
                  _UnitChip(
                    label: 'Минуты',
                    selected: _customUnit == 'minutes',
                    onTap: () => setState(() => _customUnit = 'minutes'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _customController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                  hintText: _hintForUnit(_customUnit),
                  hintStyle: const TextStyle(color: AppColors.grey2, fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixText: _suffixForUnit(_customUnit),
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
                        'Сохранить',
                        style: AppStyle.style(16, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hintForUnit(String unit) {
    switch (unit) {
      case 'days':
        return 'Число дней';
      case 'hours':
        return 'Число часов';
      default:
        return 'Число минут';
    }
  }

  String _suffixForUnit(String unit) {
    switch (unit) {
      case 'days':
        return 'дн.';
      case 'hours':
        return 'ч.';
      default:
        return 'мин.';
    }
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
            color: isSelected ? AppColors.brandColor2.withOpacity(0.3) : AppColors.brandColor,
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

class _UnitChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UnitChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.buttonColor : AppColors.grey,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.style(
            14,
            color: AppColors.black,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
