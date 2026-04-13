import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';

class BaseRepository<T extends Table, D> {
  final AppDatabase db;
  final TableInfo<T, D> table;

  BaseRepository(this.db, this.table);
  Stream<List<CalendarEntryModel>> watchEntriesByDate(DateTime targetDate) {
    return watchByDate(targetDate).map((entities) {
      // Конвертируем список системных объектов в наши модели
      return entities.map((e) => CalendarEntryModel.fromEntity(e as CalendarEntry)).toList();
    });
  }

  // 1. Метод для генерации постоянного пути (вызывай его в UI/Cubit)
  Future<String> generateLocalPath(String originalPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final String folderPath = p.join(appDir.path, 'stored_media');

    final directory = Directory(folderPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(originalPath)}";
    return p.join(folderPath, fileName);
  }

  Future<int> saveFilePermanently({
    required String originalPath,
    required String newPath,
    required Insertable<D> entry, // Ошибка "argument_type_not_assignable" исчезнет здесь
  }) async {
    await File(originalPath).copy(newPath);
    return db.into(table).insert(entry);
  }

  Stream<List<D>> watchByDate(DateTime targetDate) {
    // 1. Создаем временной диапазон для поиска (начало и конец дня)
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));

    final query = db.select(table)
      ..where((tbl) {
        // 2. Находим колонку 'date' динамически и приводим к типу Expression
        final dateColumn = (tbl as dynamic).date as Expression<DateTime>;

        // 3. Используем фильтрацию по диапазону
        return dateColumn.isBetweenValues(startOfDay, endOfDay);
      });

    return query.watch();
  }

  Stream<List<D>> watchByRange(DateTime start, DateTime end) {
    final query = db.select(table)
      ..where((tbl) {
        // Находим колонку 'date' динамически
        final dateColumn = (tbl as dynamic).date as Expression<DateTime>;

        // Используем эффективный поиск по диапазону
        return dateColumn.isBetweenValues(start, end);
      });

    return query.watch();
  }
}
