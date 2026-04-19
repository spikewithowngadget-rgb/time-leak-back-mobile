// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CalendarEntriesTable extends CalendarEntries
    with TableInfo<$CalendarEntriesTable, CalendarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extensionMeta = const VerificationMeta(
    'extension',
  );
  @override
  late final GeneratedColumn<String> extension = GeneratedColumn<String>(
    'extension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backendNoteIdMeta = const VerificationMeta(
    'backendNoteId',
  );
  @override
  late final GeneratedColumn<String> backendNoteId = GeneratedColumn<String>(
    'backend_note_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localPath,
    originalName,
    extension,
    type,
    date,
    reminderMinutes,
    title,
    backendNoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('extension')) {
      context.handle(
        _extensionMeta,
        extension.isAcceptableOrUnknown(data['extension']!, _extensionMeta),
      );
    } else if (isInserting) {
      context.missing(_extensionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('backend_note_id')) {
      context.handle(
        _backendNoteIdMeta,
        backendNoteId.isAcceptableOrUnknown(
          data['backend_note_id']!,
          _backendNoteIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      extension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extension'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      backendNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backend_note_id'],
      ),
    );
  }

  @override
  $CalendarEntriesTable createAlias(String alias) {
    return $CalendarEntriesTable(attachedDatabase, alias);
  }
}

class CalendarEntry extends DataClass implements Insertable<CalendarEntry> {
  final int id;
  final String localPath;
  final String originalName;
  final String extension;
  final String type;
  final DateTime date;
  final int? reminderMinutes;
  final String? title;

  /// Id заметки на бэкенде (для синхронизации с API).
  final String? backendNoteId;
  const CalendarEntry({
    required this.id,
    required this.localPath,
    required this.originalName,
    required this.extension,
    required this.type,
    required this.date,
    this.reminderMinutes,
    this.title,
    this.backendNoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_path'] = Variable<String>(localPath);
    map['original_name'] = Variable<String>(originalName);
    map['extension'] = Variable<String>(extension);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || backendNoteId != null) {
      map['backend_note_id'] = Variable<String>(backendNoteId);
    }
    return map;
  }

  CalendarEntriesCompanion toCompanion(bool nullToAbsent) {
    return CalendarEntriesCompanion(
      id: Value(id),
      localPath: Value(localPath),
      originalName: Value(originalName),
      extension: Value(extension),
      type: Value(type),
      date: Value(date),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      backendNoteId: backendNoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(backendNoteId),
    );
  }

  factory CalendarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEntry(
      id: serializer.fromJson<int>(json['id']),
      localPath: serializer.fromJson<String>(json['localPath']),
      originalName: serializer.fromJson<String>(json['originalName']),
      extension: serializer.fromJson<String>(json['extension']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      title: serializer.fromJson<String?>(json['title']),
      backendNoteId: serializer.fromJson<String?>(json['backendNoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localPath': serializer.toJson<String>(localPath),
      'originalName': serializer.toJson<String>(originalName),
      'extension': serializer.toJson<String>(extension),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'title': serializer.toJson<String?>(title),
      'backendNoteId': serializer.toJson<String?>(backendNoteId),
    };
  }

  CalendarEntry copyWith({
    int? id,
    String? localPath,
    String? originalName,
    String? extension,
    String? type,
    DateTime? date,
    Value<int?> reminderMinutes = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> backendNoteId = const Value.absent(),
  }) => CalendarEntry(
    id: id ?? this.id,
    localPath: localPath ?? this.localPath,
    originalName: originalName ?? this.originalName,
    extension: extension ?? this.extension,
    type: type ?? this.type,
    date: date ?? this.date,
    reminderMinutes: reminderMinutes.present
        ? reminderMinutes.value
        : this.reminderMinutes,
    title: title.present ? title.value : this.title,
    backendNoteId: backendNoteId.present
        ? backendNoteId.value
        : this.backendNoteId,
  );
  CalendarEntry copyWithCompanion(CalendarEntriesCompanion data) {
    return CalendarEntry(
      id: data.id.present ? data.id.value : this.id,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      extension: data.extension.present ? data.extension.value : this.extension,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      title: data.title.present ? data.title.value : this.title,
      backendNoteId: data.backendNoteId.present
          ? data.backendNoteId.value
          : this.backendNoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEntry(')
          ..write('id: $id, ')
          ..write('localPath: $localPath, ')
          ..write('originalName: $originalName, ')
          ..write('extension: $extension, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('title: $title, ')
          ..write('backendNoteId: $backendNoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localPath,
    originalName,
    extension,
    type,
    date,
    reminderMinutes,
    title,
    backendNoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEntry &&
          other.id == this.id &&
          other.localPath == this.localPath &&
          other.originalName == this.originalName &&
          other.extension == this.extension &&
          other.type == this.type &&
          other.date == this.date &&
          other.reminderMinutes == this.reminderMinutes &&
          other.title == this.title &&
          other.backendNoteId == this.backendNoteId);
}

class CalendarEntriesCompanion extends UpdateCompanion<CalendarEntry> {
  final Value<int> id;
  final Value<String> localPath;
  final Value<String> originalName;
  final Value<String> extension;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<int?> reminderMinutes;
  final Value<String?> title;
  final Value<String?> backendNoteId;
  const CalendarEntriesCompanion({
    this.id = const Value.absent(),
    this.localPath = const Value.absent(),
    this.originalName = const Value.absent(),
    this.extension = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.title = const Value.absent(),
    this.backendNoteId = const Value.absent(),
  });
  CalendarEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String localPath,
    required String originalName,
    required String extension,
    required String type,
    required DateTime date,
    this.reminderMinutes = const Value.absent(),
    this.title = const Value.absent(),
    this.backendNoteId = const Value.absent(),
  }) : localPath = Value(localPath),
       originalName = Value(originalName),
       extension = Value(extension),
       type = Value(type),
       date = Value(date);
  static Insertable<CalendarEntry> custom({
    Expression<int>? id,
    Expression<String>? localPath,
    Expression<String>? originalName,
    Expression<String>? extension,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<int>? reminderMinutes,
    Expression<String>? title,
    Expression<String>? backendNoteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localPath != null) 'local_path': localPath,
      if (originalName != null) 'original_name': originalName,
      if (extension != null) 'extension': extension,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (title != null) 'title': title,
      if (backendNoteId != null) 'backend_note_id': backendNoteId,
    });
  }

  CalendarEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? localPath,
    Value<String>? originalName,
    Value<String>? extension,
    Value<String>? type,
    Value<DateTime>? date,
    Value<int?>? reminderMinutes,
    Value<String?>? title,
    Value<String?>? backendNoteId,
  }) {
    return CalendarEntriesCompanion(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      originalName: originalName ?? this.originalName,
      extension: extension ?? this.extension,
      type: type ?? this.type,
      date: date ?? this.date,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      title: title ?? this.title,
      backendNoteId: backendNoteId ?? this.backendNoteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (extension.present) {
      map['extension'] = Variable<String>(extension.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (backendNoteId.present) {
      map['backend_note_id'] = Variable<String>(backendNoteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEntriesCompanion(')
          ..write('id: $id, ')
          ..write('localPath: $localPath, ')
          ..write('originalName: $originalName, ')
          ..write('extension: $extension, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('title: $title, ')
          ..write('backendNoteId: $backendNoteId')
          ..write(')'))
        .toString();
  }
}

class $AuthTokensTable extends AuthTokens
    with TableInfo<$AuthTokensTable, AuthToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [accessToken, refreshToken];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accessToken};
  @override
  AuthToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthToken(
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      )!,
    );
  }

  @override
  $AuthTokensTable createAlias(String alias) {
    return $AuthTokensTable(attachedDatabase, alias);
  }
}

class AuthToken extends DataClass implements Insertable<AuthToken> {
  final String accessToken;
  final String refreshToken;
  const AuthToken({required this.accessToken, required this.refreshToken});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['access_token'] = Variable<String>(accessToken);
    map['refresh_token'] = Variable<String>(refreshToken);
    return map;
  }

  AuthTokensCompanion toCompanion(bool nullToAbsent) {
    return AuthTokensCompanion(
      accessToken: Value(accessToken),
      refreshToken: Value(refreshToken),
    );
  }

  factory AuthToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthToken(
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String>(refreshToken),
    };
  }

  AuthToken copyWith({String? accessToken, String? refreshToken}) => AuthToken(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
  );
  AuthToken copyWithCompanion(AuthTokensCompanion data) {
    return AuthToken(
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthToken(')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthToken &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken);
}

class AuthTokensCompanion extends UpdateCompanion<AuthToken> {
  final Value<String> accessToken;
  final Value<String> refreshToken;
  final Value<int> rowid;
  const AuthTokensCompanion({
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthTokensCompanion.insert({
    required String accessToken,
    required String refreshToken,
    this.rowid = const Value.absent(),
  }) : accessToken = Value(accessToken),
       refreshToken = Value(refreshToken);
  static Insertable<AuthToken> custom({
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthTokensCompanion copyWith({
    Value<String>? accessToken,
    Value<String>? refreshToken,
    Value<int>? rowid,
  }) {
    return AuthTokensCompanion(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthTokensCompanion(')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecuritySettingsTable extends SecuritySettings
    with TableInfo<$SecuritySettingsTable, SecuritySetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecuritySettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, pinHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SecuritySetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SecuritySetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecuritySetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
    );
  }

  @override
  $SecuritySettingsTable createAlias(String alias) {
    return $SecuritySettingsTable(attachedDatabase, alias);
  }
}

class SecuritySetting extends DataClass implements Insertable<SecuritySetting> {
  final int id;
  final String? pinHash;
  const SecuritySetting({required this.id, this.pinHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    return map;
  }

  SecuritySettingsCompanion toCompanion(bool nullToAbsent) {
    return SecuritySettingsCompanion(
      id: Value(id),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
    );
  }

  factory SecuritySetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecuritySetting(
      id: serializer.fromJson<int>(json['id']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pinHash': serializer.toJson<String?>(pinHash),
    };
  }

  SecuritySetting copyWith({
    int? id,
    Value<String?> pinHash = const Value.absent(),
  }) => SecuritySetting(
    id: id ?? this.id,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
  );
  SecuritySetting copyWithCompanion(SecuritySettingsCompanion data) {
    return SecuritySetting(
      id: data.id.present ? data.id.value : this.id,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecuritySetting(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pinHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecuritySetting &&
          other.id == this.id &&
          other.pinHash == this.pinHash);
}

class SecuritySettingsCompanion extends UpdateCompanion<SecuritySetting> {
  final Value<int> id;
  final Value<String?> pinHash;
  const SecuritySettingsCompanion({
    this.id = const Value.absent(),
    this.pinHash = const Value.absent(),
  });
  SecuritySettingsCompanion.insert({
    this.id = const Value.absent(),
    this.pinHash = const Value.absent(),
  });
  static Insertable<SecuritySetting> custom({
    Expression<int>? id,
    Expression<String>? pinHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pinHash != null) 'pin_hash': pinHash,
    });
  }

  SecuritySettingsCompanion copyWith({
    Value<int>? id,
    Value<String?>? pinHash,
  }) {
    return SecuritySettingsCompanion(
      id: id ?? this.id,
      pinHash: pinHash ?? this.pinHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecuritySettingsCompanion(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CalendarEntriesTable calendarEntries = $CalendarEntriesTable(
    this,
  );
  late final $AuthTokensTable authTokens = $AuthTokensTable(this);
  late final $SecuritySettingsTable securitySettings = $SecuritySettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    calendarEntries,
    authTokens,
    securitySettings,
  ];
}

typedef $$CalendarEntriesTableCreateCompanionBuilder =
    CalendarEntriesCompanion Function({
      Value<int> id,
      required String localPath,
      required String originalName,
      required String extension,
      required String type,
      required DateTime date,
      Value<int?> reminderMinutes,
      Value<String?> title,
      Value<String?> backendNoteId,
    });
typedef $$CalendarEntriesTableUpdateCompanionBuilder =
    CalendarEntriesCompanion Function({
      Value<int> id,
      Value<String> localPath,
      Value<String> originalName,
      Value<String> extension,
      Value<String> type,
      Value<DateTime> date,
      Value<int?> reminderMinutes,
      Value<String?> title,
      Value<String?> backendNoteId,
    });

class $$CalendarEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backendNoteId => $composableBuilder(
    column: $table.backendNoteId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backendNoteId => $composableBuilder(
    column: $table.backendNoteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extension =>
      $composableBuilder(column: $table.extension, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get backendNoteId => $composableBuilder(
    column: $table.backendNoteId,
    builder: (column) => column,
  );
}

class $$CalendarEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarEntriesTable,
          CalendarEntry,
          $$CalendarEntriesTableFilterComposer,
          $$CalendarEntriesTableOrderingComposer,
          $$CalendarEntriesTableAnnotationComposer,
          $$CalendarEntriesTableCreateCompanionBuilder,
          $$CalendarEntriesTableUpdateCompanionBuilder,
          (
            CalendarEntry,
            BaseReferences<_$AppDatabase, $CalendarEntriesTable, CalendarEntry>,
          ),
          CalendarEntry,
          PrefetchHooks Function()
        > {
  $$CalendarEntriesTableTableManager(
    _$AppDatabase db,
    $CalendarEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String> extension = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> backendNoteId = const Value.absent(),
              }) => CalendarEntriesCompanion(
                id: id,
                localPath: localPath,
                originalName: originalName,
                extension: extension,
                type: type,
                date: date,
                reminderMinutes: reminderMinutes,
                title: title,
                backendNoteId: backendNoteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localPath,
                required String originalName,
                required String extension,
                required String type,
                required DateTime date,
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> backendNoteId = const Value.absent(),
              }) => CalendarEntriesCompanion.insert(
                id: id,
                localPath: localPath,
                originalName: originalName,
                extension: extension,
                type: type,
                date: date,
                reminderMinutes: reminderMinutes,
                title: title,
                backendNoteId: backendNoteId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarEntriesTable,
      CalendarEntry,
      $$CalendarEntriesTableFilterComposer,
      $$CalendarEntriesTableOrderingComposer,
      $$CalendarEntriesTableAnnotationComposer,
      $$CalendarEntriesTableCreateCompanionBuilder,
      $$CalendarEntriesTableUpdateCompanionBuilder,
      (
        CalendarEntry,
        BaseReferences<_$AppDatabase, $CalendarEntriesTable, CalendarEntry>,
      ),
      CalendarEntry,
      PrefetchHooks Function()
    >;
typedef $$AuthTokensTableCreateCompanionBuilder =
    AuthTokensCompanion Function({
      required String accessToken,
      required String refreshToken,
      Value<int> rowid,
    });
typedef $$AuthTokensTableUpdateCompanionBuilder =
    AuthTokensCompanion Function({
      Value<String> accessToken,
      Value<String> refreshToken,
      Value<int> rowid,
    });

class $$AuthTokensTableFilterComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );
}

class $$AuthTokensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthTokensTable,
          AuthToken,
          $$AuthTokensTableFilterComposer,
          $$AuthTokensTableOrderingComposer,
          $$AuthTokensTableAnnotationComposer,
          $$AuthTokensTableCreateCompanionBuilder,
          $$AuthTokensTableUpdateCompanionBuilder,
          (
            AuthToken,
            BaseReferences<_$AppDatabase, $AuthTokensTable, AuthToken>,
          ),
          AuthToken,
          PrefetchHooks Function()
        > {
  $$AuthTokensTableTableManager(_$AppDatabase db, $AuthTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accessToken = const Value.absent(),
                Value<String> refreshToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthTokensCompanion(
                accessToken: accessToken,
                refreshToken: refreshToken,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accessToken,
                required String refreshToken,
                Value<int> rowid = const Value.absent(),
              }) => AuthTokensCompanion.insert(
                accessToken: accessToken,
                refreshToken: refreshToken,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthTokensTable,
      AuthToken,
      $$AuthTokensTableFilterComposer,
      $$AuthTokensTableOrderingComposer,
      $$AuthTokensTableAnnotationComposer,
      $$AuthTokensTableCreateCompanionBuilder,
      $$AuthTokensTableUpdateCompanionBuilder,
      (AuthToken, BaseReferences<_$AppDatabase, $AuthTokensTable, AuthToken>),
      AuthToken,
      PrefetchHooks Function()
    >;
typedef $$SecuritySettingsTableCreateCompanionBuilder =
    SecuritySettingsCompanion Function({Value<int> id, Value<String?> pinHash});
typedef $$SecuritySettingsTableUpdateCompanionBuilder =
    SecuritySettingsCompanion Function({Value<int> id, Value<String?> pinHash});

class $$SecuritySettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SecuritySettingsTable> {
  $$SecuritySettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SecuritySettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SecuritySettingsTable> {
  $$SecuritySettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SecuritySettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecuritySettingsTable> {
  $$SecuritySettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);
}

class $$SecuritySettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SecuritySettingsTable,
          SecuritySetting,
          $$SecuritySettingsTableFilterComposer,
          $$SecuritySettingsTableOrderingComposer,
          $$SecuritySettingsTableAnnotationComposer,
          $$SecuritySettingsTableCreateCompanionBuilder,
          $$SecuritySettingsTableUpdateCompanionBuilder,
          (
            SecuritySetting,
            BaseReferences<
              _$AppDatabase,
              $SecuritySettingsTable,
              SecuritySetting
            >,
          ),
          SecuritySetting,
          PrefetchHooks Function()
        > {
  $$SecuritySettingsTableTableManager(
    _$AppDatabase db,
    $SecuritySettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecuritySettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecuritySettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecuritySettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
              }) => SecuritySettingsCompanion(id: id, pinHash: pinHash),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
              }) => SecuritySettingsCompanion.insert(id: id, pinHash: pinHash),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SecuritySettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SecuritySettingsTable,
      SecuritySetting,
      $$SecuritySettingsTableFilterComposer,
      $$SecuritySettingsTableOrderingComposer,
      $$SecuritySettingsTableAnnotationComposer,
      $$SecuritySettingsTableCreateCompanionBuilder,
      $$SecuritySettingsTableUpdateCompanionBuilder,
      (
        SecuritySetting,
        BaseReferences<_$AppDatabase, $SecuritySettingsTable, SecuritySetting>,
      ),
      SecuritySetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CalendarEntriesTableTableManager get calendarEntries =>
      $$CalendarEntriesTableTableManager(_db, _db.calendarEntries);
  $$AuthTokensTableTableManager get authTokens =>
      $$AuthTokensTableTableManager(_db, _db.authTokens);
  $$SecuritySettingsTableTableManager get securitySettings =>
      $$SecuritySettingsTableTableManager(_db, _db.securitySettings);
}
