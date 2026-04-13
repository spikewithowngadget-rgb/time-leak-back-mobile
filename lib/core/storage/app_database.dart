import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CalendarEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localPath => text()();
  TextColumn get originalName => text()();
  TextColumn get extension => text()();
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get reminderMinutes => integer().nullable()();
  TextColumn get title => text().nullable()();
  /// Id заметки на бэкенде (для синхронизации с API).
  TextColumn get backendNoteId => text().nullable()();
}

class AuthTokens extends Table {
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text()();

  @override
  Set<Column> get primaryKey => {accessToken};
}

@DriftDatabase(tables: [CalendarEntries, AuthTokens])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          await m.createTable(authTokens);
        }
        if (from < 5) {
          await m.addColumn(calendarEntries, calendarEntries.reminderMinutes);
        }
        if (from < 6) {
          await m.addColumn(calendarEntries, calendarEntries.title);
        }
        if (from < 7) {
          await m.addColumn(calendarEntries, calendarEntries.backendNoteId);
        }
      },
    );
  }

  // Метод сохранения: удаляем всё старое и записываем новое
  Future<void> updateTokens(String access, String refresh) async {
    await transaction(() async {
      await delete(authTokens).go();
      await into(authTokens).insert(AuthTokensCompanion.insert(accessToken: access, refreshToken: refresh));
    });
  }

  // Получаем единственную запись
  Future<AuthToken?> getTokens() => select(authTokens).getSingleOrNull();

  Future<void> deleteTokens() => delete(authTokens).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
