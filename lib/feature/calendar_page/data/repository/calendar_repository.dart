import 'dart:io';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/core/storage/base_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';

/// Репозиторий локальных данных календаря: get, put, update, delete.
class CalendarRepository {
  final BaseRepository<CalendarEntries, CalendarEntry> _baseRepo;
  final AppDatabase _db;

  CalendarRepository(this._baseRepo, this._db);

  // --- Get ---

  /// Записи по одной дате (разовый запрос).
  Future<List<CalendarEntryModel>> getCalendarsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
    final list = await (_db.select(_db.calendarEntries)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay)))
        .get();
    return list.map((e) => CalendarEntryModel.fromEntity(e)).toList();
  }

  /// Записи в диапазоне дат (разовый запрос).
  Future<List<CalendarEntryModel>> getCalendarsByRange(DateTime start, DateTime end) async {
    final list = await (_db.select(_db.calendarEntries)..where((t) => t.date.isBetweenValues(start, end))).get();
    return list.map((e) => CalendarEntryModel.fromEntity(e)).toList();
  }

  /// Есть ли локальная запись с таким backend_note_id (после синхронизации с бэка).
  Future<bool> hasEntryWithBackendNoteId(String backendNoteId) async {
    final list = await (_db.select(_db.calendarEntries)
          ..where((t) => t.backendNoteId.equals(backendNoteId)))
        .get();
    return list.isNotEmpty;
  }

  /// Сгенерировать путь в stored_media для сохранения файла при синхронизации.
  Future<String> generateStoredPath(String extension) async {
    return _baseRepo.generateLocalPath('sync.$extension');
  }

  /// Вставить запись, пришедшую с бэка (файл уже лежит по [localPath]).
  Future<void> insertSyncedEntry({
    required String localPath,
    required String originalName,
    required String extension,
    required String type,
    required DateTime date,
    required String title,
    required String backendNoteId,
  }) async {
    await _db.into(_db.calendarEntries).insert(
          CalendarEntriesCompanion.insert(
            localPath: localPath,
            originalName: originalName,
            extension: extension,
            type: type,
            date: date,
            title: Value(title),
            backendNoteId: Value(backendNoteId),
          ),
        );
  }

  /// Поток записей по дате (для UI).
  Stream<List<CalendarEntryModel>> watchCalendarsByDate(DateTime date) {
    return _baseRepo.watchByDate(date).map(
          (entities) => entities.map((e) => CalendarEntryModel.fromEntity(e)).toList(),
        );
  }

  /// Поток записей в диапазоне (для точек в календаре).
  Stream<List<CalendarEntryModel>> watchCalendarsByRange(DateTime start, DateTime end) {
    return _baseRepo.watchByRange(start, end).map(
          (entities) => entities.map((e) => CalendarEntryModel.fromEntity(e)).toList(),
        );
  }

  // --- Put (добавить) ---

  /// Шаблон заголовка по умолчанию: «Напоминание от TimeLeak: 15 марта у вас заметка».
  static String defaultTitleFor(DateTime date) {
    final dateStr = DateFormat('d MMMM', 'ru').format(date);
    return 'Напоминание от TimeLeak: $dateStr у вас заметка';
  }

  /// Добавить запись: копирует файл в хранилище и создаёт запись в БД.
  /// Возвращает (id новой записи, localPath файла) для синхронизации с API.
  Future<({int id, String localPath})> putCalendar({
    required String pickedPath,
    required String type,
    required DateTime date,
  }) async {
    final String localPath = await _baseRepo.generateLocalPath(pickedPath);
    final String ext = p.extension(pickedPath).replaceFirst('.', '');
    final String nameWithoutExt = p.basenameWithoutExtension(pickedPath);
    final String title = defaultTitleFor(date);

    final id = await _baseRepo.saveFilePermanently(
      originalPath: pickedPath,
      newPath: localPath,
      entry: CalendarEntriesCompanion.insert(
        localPath: localPath,
        originalName: nameWithoutExt,
        extension: ext,
        type: type,
        date: date,
        title: Value(title),
      ),
    );
    return (id: id, localPath: localPath);
  }

  // --- Update ---

  /// Обновить запись (имя, дата/время, напоминание, заголовок, id бэка).
  Future<void> updateCalendar(
    CalendarEntryModel model, {
    String? originalName,
    DateTime? date,
    int? reminderMinutes,
    String? title,
    String? backendNoteId,
  }) async {
    await (_db.update(_db.calendarEntries)..where((t) => t.id.equals(model.id))).write(
          CalendarEntriesCompanion(
            originalName: originalName != null ? Value(originalName) : const Value.absent(),
            date: date != null ? Value(date) : const Value.absent(),
            reminderMinutes: reminderMinutes != null ? Value(reminderMinutes) : const Value.absent(),
            title: title != null ? Value(title) : const Value.absent(),
            backendNoteId: backendNoteId != null ? Value(backendNoteId) : const Value.absent(),
          ),
        );
  }

  /// Привязать локальную запись к заметке на бэкенде.
  Future<void> setBackendNoteId(int entryId, String backendNoteId) async {
    await (_db.update(_db.calendarEntries)..where((t) => t.id.equals(entryId))).write(
          CalendarEntriesCompanion(backendNoteId: Value(backendNoteId)),
        );
  }

  /// Обновить только минуты напоминания для записи.
  Future<void> updateReminder(int entryId, int? minutes) async {
    await (_db.update(_db.calendarEntries)..where((t) => t.id.equals(entryId))).write(
          CalendarEntriesCompanion(reminderMinutes: minutes != null ? Value(minutes) : const Value.absent()),
        );
  }

  // --- Delete ---

  /// Удалить запись и файл с диска.
  Future<void> deleteCalendar(CalendarEntryModel model) async {
    final file = File(model.localPath);
    if (await file.exists()) await file.delete();
    await (_db.delete(_db.calendarEntries)..where((t) => t.id.equals(model.id))).go();
  }

  // --- Download (экспорт в папку Загрузки) ---

  /// Скачать файл в папку Загрузки (или Documents на iOS).
  Future<void> downloadCalendar(CalendarEntryModel model) async {
    final file = File(model.localPath);
    if (!await file.exists()) return;
    final Directory downloadsDir = Platform.isAndroid
        ? Directory('/storage/emulated/0/Download')
        : await getApplicationDocumentsDirectory();
    final String newPath = p.join(downloadsDir.path, '${model.name}.${model.extension}');
    await file.copy(newPath);
  }
}
