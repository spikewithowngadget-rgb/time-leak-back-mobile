import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/calendar_repository.dart';
import 'package:time_leak_flutter/feature/core/data/repository/notes_repository.dart';

/// Единый репозиторий: локальный календарь (CalendarRepository) + API заметок (NotesRepository).
/// Все записи хранятся локально с привязкой к id бэкенда (backend_note_id); создание/обновление/удаление синхронно с API.
class SyncedNotesRepository {
  final CalendarRepository _local;
  final NotesRepository _api;

  SyncedNotesRepository(this._local, this._api);

  // --- Чтение: только локальный источник ---

  Future<List<CalendarEntryModel>> getCalendarsByDate(DateTime date) =>
      _local.getCalendarsByDate(date);

  Future<List<CalendarEntryModel>> getCalendarsByRange(DateTime start, DateTime end) =>
      _local.getCalendarsByRange(start, end);

  Stream<List<CalendarEntryModel>> watchCalendarsByDate(DateTime date) =>
      _local.watchCalendarsByDate(date);

  Stream<List<CalendarEntryModel>> watchCalendarsByRange(DateTime start, DateTime end) =>
      _local.watchCalendarsByRange(start, end);

  /// Шаблон заголовка по умолчанию (делегируем в CalendarRepository).
  static String defaultTitleFor(DateTime date) => CalendarRepository.defaultTitleFor(date);

  // --- Запись: локально + синхронизация с API ---

  /// Добавить запись: сохраняем локально, затем создаём заметку на бэке и сохраняем backend id.
  Future<int> putCalendar({
    required String pickedPath,
    required String type,
    required DateTime date,
  }) async {
    final result = await _local.putCalendar(
      pickedPath: pickedPath,
      type: type,
      date: date,
    );
    try {
      final noteType = CalendarRepository.defaultTitleFor(date);
      final note = await _api.createNote(
        noteType: noteType,
        filePaths: [result.localPath],
      );
      await _local.setBackendNoteId(result.id, note.id);
    } catch (_) {
      // офлайн или ошибка API — запись уже есть локально
    }
    return result.id;
  }

  /// Обновить запись: локально и на бэке (если есть backendNoteId).
  Future<void> updateCalendar(
    CalendarEntryModel model, {
    String? originalName,
    DateTime? date,
    int? reminderMinutes,
    String? title,
  }) async {
    await _local.updateCalendar(
      model,
      originalName: originalName,
      date: date,
      reminderMinutes: reminderMinutes,
      title: title,
    );
    final backendId = model.backendNoteId;
    if (backendId != null && backendId.isNotEmpty) {
      try {
        await _api.updateNote(
          id: backendId,
          noteType: title ?? model.title ?? CalendarRepository.defaultTitleFor(model.date),
        );
      } catch (_) {}
    }
  }

  /// Обновить только напоминание (только локально).
  Future<void> updateReminder(int entryId, int? minutes) =>
      _local.updateReminder(entryId, minutes);

  /// Привязать локальную запись к id бэка (внутренний метод).
  Future<void> setBackendNoteId(int entryId, String backendNoteId) =>
      _local.setBackendNoteId(entryId, backendNoteId);

  /// Удалить запись: сначала на бэке (если есть backendNoteId), затем локально и файл.
  Future<void> deleteCalendar(CalendarEntryModel model) async {
    final backendId = model.backendNoteId;
    if (backendId != null && backendId.isNotEmpty) {
      try {
        await _api.deleteNote(backendId);
      } catch (_) {}
    }
    await _local.deleteCalendar(model);
  }

  /// Скачать файл в папку «Загрузки».
  Future<void> downloadCalendar(CalendarEntryModel model) =>
      _local.downloadCalendar(model);

  /// Синхронизация с бэком: загрузить заметки с API и сохранить в локальную БД (для пользователя после переустановки/логина).
  Future<void> syncFromBackend() async {
    final response = await _api.getNotes();
    for (final note in response.data) {
      final alreadyExists = await _local.hasEntryWithBackendNoteId(note.id);
      if (alreadyExists) continue;
      if (note.noteFiles.isEmpty) continue;

      final firstUrl = note.noteFiles.first;
      final (type, extension, name) = _parseNoteFileUrl(firstUrl);
      final savePath = await _local.generateStoredPath(extension);

      try {
        await _api.downloadToPath(firstUrl, savePath);
      } catch (_) {
        continue;
      }

      await _local.insertSyncedEntry(
        localPath: savePath,
        originalName: name,
        extension: extension,
        type: type,
        date: note.createdAt,
        title: note.noteType,
        backendNoteId: note.id,
      );
    }
  }

  /// Из URL вида .../note-files/document/uuid.pdf извлечь type, extension, name.
  static (String type, String extension, String name) _parseNoteFileUrl(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    String type = 'document';
    String extension = 'bin';
    String name = 'file';
    if (segments.length >= 2) {
      type = segments[segments.length - 2];
      final last = segments.last;
      final dot = last.lastIndexOf('.');
      if (dot > 0) {
        extension = last.substring(dot + 1);
        name = last.substring(0, dot);
      } else {
        name = last;
      }
    }
    return (type, extension, name);
  }
}
