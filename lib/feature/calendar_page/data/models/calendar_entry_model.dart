import 'package:time_leak_flutter/core/storage/app_database.dart';

class CalendarEntryModel {
  final int id;
  final String localPath;
  final String name;
  final String extension;
  final String type;
  final DateTime date;
  /// Минуты до напоминания (null — не задано, 1440 — каждый день).
  final int? reminderMinutes;
  /// Заголовок заметки (по умолчанию «Напоминание от TimeLeak: 15 марта у вас заметка»).
  final String? title;
  /// Id заметки на бэкенде (uuid из API).
  final String? backendNoteId;

  CalendarEntryModel({
    required this.id,
    required this.localPath,
    required this.name,
    required this.extension,
    required this.type,
    required this.date,
    this.reminderMinutes,
    this.title,
    this.backendNoteId,
  });

  String get fullName => '$name.$extension';

  factory CalendarEntryModel.fromEntity(CalendarEntry entity) {
    return CalendarEntryModel(
      id: entity.id,
      localPath: entity.localPath,
      name: entity.originalName,
      extension: entity.extension,
      type: entity.type,
      date: entity.date,
      reminderMinutes: entity.reminderMinutes,
      title: entity.title,
      backendNoteId: entity.backendNoteId,
    );
  }
}
