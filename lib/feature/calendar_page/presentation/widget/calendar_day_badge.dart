import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';

/// Цвет бейджа с числом на ячейке календаря.
/// TimeLeak (оранжевый) — напоминание задано, дата ещё не наступила.
/// Красный — сегодня, дата напоминания наступила или напоминание не задано.
Color calendarDayBadgeColor(Iterable<CalendarEntryModel> entries, {DateTime? day}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if (day != null) {
    final cellDay = DateTime(day.year, day.month, day.day);
    if (cellDay == today) return AppColors.badgeToday;
  }

  var hasPendingReminder = false;

  for (final entry in entries) {
    final minutes = entry.reminderMinutes;
    if (minutes == null || minutes <= 0) {
      return AppColors.red;
    }

    final reminderAt = entry.reminderAt;
    if (reminderAt == null) {
      return AppColors.red;
    }

    final reminderDay = DateTime(reminderAt.year, reminderAt.month, reminderAt.day);
    if (!today.isBefore(reminderDay)) {
      return AppColors.red;
    }
    hasPendingReminder = true;
  }

  return hasPendingReminder ? AppColors.buttonColor : AppColors.red;
}
