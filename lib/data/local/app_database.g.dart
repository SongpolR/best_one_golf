// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  @override
  List<GeneratedColumn> get $columns => [id, languageCode, currencyCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final String languageCode;
  final String currencyCode;
  const AppSettingsTableData(
      {required this.id,
      required this.languageCode,
      required this.currencyCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['language_code'] = Variable<String>(languageCode);
    map['currency_code'] = Variable<String>(currencyCode);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      languageCode: Value(languageCode),
      currencyCode: Value(currencyCode),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'languageCode': serializer.toJson<String>(languageCode),
      'currencyCode': serializer.toJson<String>(currencyCode),
    };
  }

  AppSettingsTableData copyWith(
          {int? id, String? languageCode, String? currencyCode}) =>
      AppSettingsTableData(
        id: id ?? this.id,
        languageCode: languageCode ?? this.languageCode,
        currencyCode: currencyCode ?? this.currencyCode,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('languageCode: $languageCode, ')
          ..write('currencyCode: $currencyCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, languageCode, currencyCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.languageCode == this.languageCode &&
          other.currencyCode == this.currencyCode);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<String> languageCode;
  final Value<String> currencyCode;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.currencyCode = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.currencyCode = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? languageCode,
    Expression<String>? currencyCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (languageCode != null) 'language_code': languageCode,
      if (currencyCode != null) 'currency_code': currencyCode,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? languageCode,
      Value<String>? currencyCode}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('languageCode: $languageCode, ')
          ..write('currencyCode: $currencyCode')
          ..write(')'))
        .toString();
  }
}

class $GamesTableTable extends GamesTable
    with TableInfo<$GamesTableTable, GamesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ongoing'));
  static const VerificationMeta _totalHolesMeta =
      const VerificationMeta('totalHoles');
  @override
  late final GeneratedColumn<int> totalHoles = GeneratedColumn<int>(
      'total_holes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(18));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, mode, status, totalHoles, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_table';
  @override
  VerificationContext validateIntegrity(Insertable<GamesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('total_holes')) {
      context.handle(
          _totalHolesMeta,
          totalHoles.isAcceptableOrUnknown(
              data['total_holes']!, _totalHolesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GamesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalHoles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_holes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GamesTableTable createAlias(String alias) {
    return $GamesTableTable(attachedDatabase, alias);
  }
}

class GamesTableData extends DataClass implements Insertable<GamesTableData> {
  final String id;
  final String title;
  final String mode;
  final String status;
  final int totalHoles;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GamesTableData(
      {required this.id,
      required this.title,
      required this.mode,
      required this.status,
      required this.totalHoles,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['mode'] = Variable<String>(mode);
    map['status'] = Variable<String>(status);
    map['total_holes'] = Variable<int>(totalHoles);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GamesTableCompanion toCompanion(bool nullToAbsent) {
    return GamesTableCompanion(
      id: Value(id),
      title: Value(title),
      mode: Value(mode),
      status: Value(status),
      totalHoles: Value(totalHoles),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GamesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      mode: serializer.fromJson<String>(json['mode']),
      status: serializer.fromJson<String>(json['status']),
      totalHoles: serializer.fromJson<int>(json['totalHoles']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'mode': serializer.toJson<String>(mode),
      'status': serializer.toJson<String>(status),
      'totalHoles': serializer.toJson<int>(totalHoles),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GamesTableData copyWith(
          {String? id,
          String? title,
          String? mode,
          String? status,
          int? totalHoles,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      GamesTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        mode: mode ?? this.mode,
        status: status ?? this.status,
        totalHoles: totalHoles ?? this.totalHoles,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GamesTableData copyWithCompanion(GamesTableCompanion data) {
    return GamesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      mode: data.mode.present ? data.mode.value : this.mode,
      status: data.status.present ? data.status.value : this.status,
      totalHoles:
          data.totalHoles.present ? data.totalHoles.value : this.totalHoles,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('totalHoles: $totalHoles, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, mode, status, totalHoles, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.mode == this.mode &&
          other.status == this.status &&
          other.totalHoles == this.totalHoles &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GamesTableCompanion extends UpdateCompanion<GamesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> mode;
  final Value<String> status;
  final Value<int> totalHoles;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GamesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.mode = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHoles = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesTableCompanion.insert({
    required String id,
    required String title,
    required String mode,
    this.status = const Value.absent(),
    this.totalHoles = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        mode = Value(mode),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GamesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? mode,
    Expression<String>? status,
    Expression<int>? totalHoles,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (mode != null) 'mode': mode,
      if (status != null) 'status': status,
      if (totalHoles != null) 'total_holes': totalHoles,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? mode,
      Value<String>? status,
      Value<int>? totalHoles,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return GamesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      totalHoles: totalHoles ?? this.totalHoles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalHoles.present) {
      map['total_holes'] = Variable<int>(totalHoles.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('totalHoles: $totalHoles, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayersTableTable extends PlayersTable
    with TableInfo<$PlayersTableTable, PlayersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playerOrderMeta =
      const VerificationMeta('playerOrder');
  @override
  late final GeneratedColumn<int> playerOrder = GeneratedColumn<int>(
      'player_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
      'team_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, gameId, name, playerOrder, teamId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlayersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('player_order')) {
      context.handle(
          _playerOrderMeta,
          playerOrder.isAcceptableOrUnknown(
              data['player_order']!, _playerOrderMeta));
    } else if (isInserting) {
      context.missing(_playerOrderMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(_teamIdMeta,
          teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      playerOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_order'])!,
      teamId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}team_id']),
    );
  }

  @override
  $PlayersTableTable createAlias(String alias) {
    return $PlayersTableTable(attachedDatabase, alias);
  }
}

class PlayersTableData extends DataClass
    implements Insertable<PlayersTableData> {
  final String id;
  final String gameId;
  final String name;
  final int playerOrder;
  final String? teamId;
  const PlayersTableData(
      {required this.id,
      required this.gameId,
      required this.name,
      required this.playerOrder,
      this.teamId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['name'] = Variable<String>(name);
    map['player_order'] = Variable<int>(playerOrder);
    if (!nullToAbsent || teamId != null) {
      map['team_id'] = Variable<String>(teamId);
    }
    return map;
  }

  PlayersTableCompanion toCompanion(bool nullToAbsent) {
    return PlayersTableCompanion(
      id: Value(id),
      gameId: Value(gameId),
      name: Value(name),
      playerOrder: Value(playerOrder),
      teamId:
          teamId == null && nullToAbsent ? const Value.absent() : Value(teamId),
    );
  }

  factory PlayersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayersTableData(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      name: serializer.fromJson<String>(json['name']),
      playerOrder: serializer.fromJson<int>(json['playerOrder']),
      teamId: serializer.fromJson<String?>(json['teamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'name': serializer.toJson<String>(name),
      'playerOrder': serializer.toJson<int>(playerOrder),
      'teamId': serializer.toJson<String?>(teamId),
    };
  }

  PlayersTableData copyWith(
          {String? id,
          String? gameId,
          String? name,
          int? playerOrder,
          Value<String?> teamId = const Value.absent()}) =>
      PlayersTableData(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        name: name ?? this.name,
        playerOrder: playerOrder ?? this.playerOrder,
        teamId: teamId.present ? teamId.value : this.teamId,
      );
  PlayersTableData copyWithCompanion(PlayersTableCompanion data) {
    return PlayersTableData(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
      playerOrder:
          data.playerOrder.present ? data.playerOrder.value : this.playerOrder,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayersTableData(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('playerOrder: $playerOrder, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, name, playerOrder, teamId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayersTableData &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.name == this.name &&
          other.playerOrder == this.playerOrder &&
          other.teamId == this.teamId);
}

class PlayersTableCompanion extends UpdateCompanion<PlayersTableData> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> name;
  final Value<int> playerOrder;
  final Value<String?> teamId;
  final Value<int> rowid;
  const PlayersTableCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.playerOrder = const Value.absent(),
    this.teamId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersTableCompanion.insert({
    required String id,
    required String gameId,
    required String name,
    required int playerOrder,
    this.teamId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        gameId = Value(gameId),
        name = Value(name),
        playerOrder = Value(playerOrder);
  static Insertable<PlayersTableData> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? name,
    Expression<int>? playerOrder,
    Expression<String>? teamId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (playerOrder != null) 'player_order': playerOrder,
      if (teamId != null) 'team_id': teamId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? gameId,
      Value<String>? name,
      Value<int>? playerOrder,
      Value<String?>? teamId,
      Value<int>? rowid}) {
    return PlayersTableCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      playerOrder: playerOrder ?? this.playerOrder,
      teamId: teamId ?? this.teamId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (playerOrder.present) {
      map['player_order'] = Variable<int>(playerOrder.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersTableCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('playerOrder: $playerOrder, ')
          ..write('teamId: $teamId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeamsTableTable extends TeamsTable
    with TableInfo<$TeamsTableTable, TeamsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teamOrderMeta =
      const VerificationMeta('teamOrder');
  @override
  late final GeneratedColumn<int> teamOrder = GeneratedColumn<int>(
      'team_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, gameId, name, teamOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams_table';
  @override
  VerificationContext validateIntegrity(Insertable<TeamsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('team_order')) {
      context.handle(_teamOrderMeta,
          teamOrder.isAcceptableOrUnknown(data['team_order']!, _teamOrderMeta));
    } else if (isInserting) {
      context.missing(_teamOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      teamOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}team_order'])!,
    );
  }

  @override
  $TeamsTableTable createAlias(String alias) {
    return $TeamsTableTable(attachedDatabase, alias);
  }
}

class TeamsTableData extends DataClass implements Insertable<TeamsTableData> {
  final String id;
  final String gameId;
  final String name;
  final int teamOrder;
  const TeamsTableData(
      {required this.id,
      required this.gameId,
      required this.name,
      required this.teamOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['name'] = Variable<String>(name);
    map['team_order'] = Variable<int>(teamOrder);
    return map;
  }

  TeamsTableCompanion toCompanion(bool nullToAbsent) {
    return TeamsTableCompanion(
      id: Value(id),
      gameId: Value(gameId),
      name: Value(name),
      teamOrder: Value(teamOrder),
    );
  }

  factory TeamsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamsTableData(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      name: serializer.fromJson<String>(json['name']),
      teamOrder: serializer.fromJson<int>(json['teamOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'name': serializer.toJson<String>(name),
      'teamOrder': serializer.toJson<int>(teamOrder),
    };
  }

  TeamsTableData copyWith(
          {String? id, String? gameId, String? name, int? teamOrder}) =>
      TeamsTableData(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        name: name ?? this.name,
        teamOrder: teamOrder ?? this.teamOrder,
      );
  TeamsTableData copyWithCompanion(TeamsTableCompanion data) {
    return TeamsTableData(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
      teamOrder: data.teamOrder.present ? data.teamOrder.value : this.teamOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamsTableData(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('teamOrder: $teamOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, name, teamOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamsTableData &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.name == this.name &&
          other.teamOrder == this.teamOrder);
}

class TeamsTableCompanion extends UpdateCompanion<TeamsTableData> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> name;
  final Value<int> teamOrder;
  final Value<int> rowid;
  const TeamsTableCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.teamOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamsTableCompanion.insert({
    required String id,
    required String gameId,
    required String name,
    required int teamOrder,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        gameId = Value(gameId),
        name = Value(name),
        teamOrder = Value(teamOrder);
  static Insertable<TeamsTableData> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? name,
    Expression<int>? teamOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (teamOrder != null) 'team_order': teamOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? gameId,
      Value<String>? name,
      Value<int>? teamOrder,
      Value<int>? rowid}) {
    return TeamsTableCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      teamOrder: teamOrder ?? this.teamOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (teamOrder.present) {
      map['team_order'] = Variable<int>(teamOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsTableCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('teamOrder: $teamOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameRuleSettingsTableTable extends GameRuleSettingsTable
    with TableInfo<$GameRuleSettingsTableTable, GameRuleSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameRuleSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bestOneEnabledMeta =
      const VerificationMeta('bestOneEnabled');
  @override
  late final GeneratedColumn<bool> bestOneEnabled = GeneratedColumn<bool>(
      'best_one_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("best_one_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _bestTwoEnabledMeta =
      const VerificationMeta('bestTwoEnabled');
  @override
  late final GeneratedColumn<bool> bestTwoEnabled = GeneratedColumn<bool>(
      'best_two_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("best_two_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sharedBetDefaultMeta =
      const VerificationMeta('sharedBetDefault');
  @override
  late final GeneratedColumn<bool> sharedBetDefault = GeneratedColumn<bool>(
      'shared_bet_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("shared_bet_default" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _bestOneAmountMeta =
      const VerificationMeta('bestOneAmount');
  @override
  late final GeneratedColumn<int> bestOneAmount = GeneratedColumn<int>(
      'best_one_amount', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bestTwoAmountMeta =
      const VerificationMeta('bestTwoAmount');
  @override
  late final GeneratedColumn<int> bestTwoAmount = GeneratedColumn<int>(
      'best_two_amount', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        gameId,
        bestOneEnabled,
        bestTwoEnabled,
        sharedBetDefault,
        bestOneAmount,
        bestTwoAmount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_rule_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<GameRuleSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('best_one_enabled')) {
      context.handle(
          _bestOneEnabledMeta,
          bestOneEnabled.isAcceptableOrUnknown(
              data['best_one_enabled']!, _bestOneEnabledMeta));
    }
    if (data.containsKey('best_two_enabled')) {
      context.handle(
          _bestTwoEnabledMeta,
          bestTwoEnabled.isAcceptableOrUnknown(
              data['best_two_enabled']!, _bestTwoEnabledMeta));
    }
    if (data.containsKey('shared_bet_default')) {
      context.handle(
          _sharedBetDefaultMeta,
          sharedBetDefault.isAcceptableOrUnknown(
              data['shared_bet_default']!, _sharedBetDefaultMeta));
    }
    if (data.containsKey('best_one_amount')) {
      context.handle(
          _bestOneAmountMeta,
          bestOneAmount.isAcceptableOrUnknown(
              data['best_one_amount']!, _bestOneAmountMeta));
    }
    if (data.containsKey('best_two_amount')) {
      context.handle(
          _bestTwoAmountMeta,
          bestTwoAmount.isAcceptableOrUnknown(
              data['best_two_amount']!, _bestTwoAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId};
  @override
  GameRuleSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameRuleSettingsTableData(
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      bestOneEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}best_one_enabled'])!,
      bestTwoEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}best_two_enabled'])!,
      sharedBetDefault: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}shared_bet_default'])!,
      bestOneAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best_one_amount']),
      bestTwoAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best_two_amount']),
    );
  }

  @override
  $GameRuleSettingsTableTable createAlias(String alias) {
    return $GameRuleSettingsTableTable(attachedDatabase, alias);
  }
}

class GameRuleSettingsTableData extends DataClass
    implements Insertable<GameRuleSettingsTableData> {
  final String gameId;
  final bool bestOneEnabled;
  final bool bestTwoEnabled;
  final bool sharedBetDefault;
  final int? bestOneAmount;
  final int? bestTwoAmount;
  const GameRuleSettingsTableData(
      {required this.gameId,
      required this.bestOneEnabled,
      required this.bestTwoEnabled,
      required this.sharedBetDefault,
      this.bestOneAmount,
      this.bestTwoAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['best_one_enabled'] = Variable<bool>(bestOneEnabled);
    map['best_two_enabled'] = Variable<bool>(bestTwoEnabled);
    map['shared_bet_default'] = Variable<bool>(sharedBetDefault);
    if (!nullToAbsent || bestOneAmount != null) {
      map['best_one_amount'] = Variable<int>(bestOneAmount);
    }
    if (!nullToAbsent || bestTwoAmount != null) {
      map['best_two_amount'] = Variable<int>(bestTwoAmount);
    }
    return map;
  }

  GameRuleSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return GameRuleSettingsTableCompanion(
      gameId: Value(gameId),
      bestOneEnabled: Value(bestOneEnabled),
      bestTwoEnabled: Value(bestTwoEnabled),
      sharedBetDefault: Value(sharedBetDefault),
      bestOneAmount: bestOneAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(bestOneAmount),
      bestTwoAmount: bestTwoAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(bestTwoAmount),
    );
  }

  factory GameRuleSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameRuleSettingsTableData(
      gameId: serializer.fromJson<String>(json['gameId']),
      bestOneEnabled: serializer.fromJson<bool>(json['bestOneEnabled']),
      bestTwoEnabled: serializer.fromJson<bool>(json['bestTwoEnabled']),
      sharedBetDefault: serializer.fromJson<bool>(json['sharedBetDefault']),
      bestOneAmount: serializer.fromJson<int?>(json['bestOneAmount']),
      bestTwoAmount: serializer.fromJson<int?>(json['bestTwoAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'bestOneEnabled': serializer.toJson<bool>(bestOneEnabled),
      'bestTwoEnabled': serializer.toJson<bool>(bestTwoEnabled),
      'sharedBetDefault': serializer.toJson<bool>(sharedBetDefault),
      'bestOneAmount': serializer.toJson<int?>(bestOneAmount),
      'bestTwoAmount': serializer.toJson<int?>(bestTwoAmount),
    };
  }

  GameRuleSettingsTableData copyWith(
          {String? gameId,
          bool? bestOneEnabled,
          bool? bestTwoEnabled,
          bool? sharedBetDefault,
          Value<int?> bestOneAmount = const Value.absent(),
          Value<int?> bestTwoAmount = const Value.absent()}) =>
      GameRuleSettingsTableData(
        gameId: gameId ?? this.gameId,
        bestOneEnabled: bestOneEnabled ?? this.bestOneEnabled,
        bestTwoEnabled: bestTwoEnabled ?? this.bestTwoEnabled,
        sharedBetDefault: sharedBetDefault ?? this.sharedBetDefault,
        bestOneAmount:
            bestOneAmount.present ? bestOneAmount.value : this.bestOneAmount,
        bestTwoAmount:
            bestTwoAmount.present ? bestTwoAmount.value : this.bestTwoAmount,
      );
  GameRuleSettingsTableData copyWithCompanion(
      GameRuleSettingsTableCompanion data) {
    return GameRuleSettingsTableData(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      bestOneEnabled: data.bestOneEnabled.present
          ? data.bestOneEnabled.value
          : this.bestOneEnabled,
      bestTwoEnabled: data.bestTwoEnabled.present
          ? data.bestTwoEnabled.value
          : this.bestTwoEnabled,
      sharedBetDefault: data.sharedBetDefault.present
          ? data.sharedBetDefault.value
          : this.sharedBetDefault,
      bestOneAmount: data.bestOneAmount.present
          ? data.bestOneAmount.value
          : this.bestOneAmount,
      bestTwoAmount: data.bestTwoAmount.present
          ? data.bestTwoAmount.value
          : this.bestTwoAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameRuleSettingsTableData(')
          ..write('gameId: $gameId, ')
          ..write('bestOneEnabled: $bestOneEnabled, ')
          ..write('bestTwoEnabled: $bestTwoEnabled, ')
          ..write('sharedBetDefault: $sharedBetDefault, ')
          ..write('bestOneAmount: $bestOneAmount, ')
          ..write('bestTwoAmount: $bestTwoAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, bestOneEnabled, bestTwoEnabled,
      sharedBetDefault, bestOneAmount, bestTwoAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameRuleSettingsTableData &&
          other.gameId == this.gameId &&
          other.bestOneEnabled == this.bestOneEnabled &&
          other.bestTwoEnabled == this.bestTwoEnabled &&
          other.sharedBetDefault == this.sharedBetDefault &&
          other.bestOneAmount == this.bestOneAmount &&
          other.bestTwoAmount == this.bestTwoAmount);
}

class GameRuleSettingsTableCompanion
    extends UpdateCompanion<GameRuleSettingsTableData> {
  final Value<String> gameId;
  final Value<bool> bestOneEnabled;
  final Value<bool> bestTwoEnabled;
  final Value<bool> sharedBetDefault;
  final Value<int?> bestOneAmount;
  final Value<int?> bestTwoAmount;
  final Value<int> rowid;
  const GameRuleSettingsTableCompanion({
    this.gameId = const Value.absent(),
    this.bestOneEnabled = const Value.absent(),
    this.bestTwoEnabled = const Value.absent(),
    this.sharedBetDefault = const Value.absent(),
    this.bestOneAmount = const Value.absent(),
    this.bestTwoAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameRuleSettingsTableCompanion.insert({
    required String gameId,
    this.bestOneEnabled = const Value.absent(),
    this.bestTwoEnabled = const Value.absent(),
    this.sharedBetDefault = const Value.absent(),
    this.bestOneAmount = const Value.absent(),
    this.bestTwoAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId);
  static Insertable<GameRuleSettingsTableData> custom({
    Expression<String>? gameId,
    Expression<bool>? bestOneEnabled,
    Expression<bool>? bestTwoEnabled,
    Expression<bool>? sharedBetDefault,
    Expression<int>? bestOneAmount,
    Expression<int>? bestTwoAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (bestOneEnabled != null) 'best_one_enabled': bestOneEnabled,
      if (bestTwoEnabled != null) 'best_two_enabled': bestTwoEnabled,
      if (sharedBetDefault != null) 'shared_bet_default': sharedBetDefault,
      if (bestOneAmount != null) 'best_one_amount': bestOneAmount,
      if (bestTwoAmount != null) 'best_two_amount': bestTwoAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameRuleSettingsTableCompanion copyWith(
      {Value<String>? gameId,
      Value<bool>? bestOneEnabled,
      Value<bool>? bestTwoEnabled,
      Value<bool>? sharedBetDefault,
      Value<int?>? bestOneAmount,
      Value<int?>? bestTwoAmount,
      Value<int>? rowid}) {
    return GameRuleSettingsTableCompanion(
      gameId: gameId ?? this.gameId,
      bestOneEnabled: bestOneEnabled ?? this.bestOneEnabled,
      bestTwoEnabled: bestTwoEnabled ?? this.bestTwoEnabled,
      sharedBetDefault: sharedBetDefault ?? this.sharedBetDefault,
      bestOneAmount: bestOneAmount ?? this.bestOneAmount,
      bestTwoAmount: bestTwoAmount ?? this.bestTwoAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (bestOneEnabled.present) {
      map['best_one_enabled'] = Variable<bool>(bestOneEnabled.value);
    }
    if (bestTwoEnabled.present) {
      map['best_two_enabled'] = Variable<bool>(bestTwoEnabled.value);
    }
    if (sharedBetDefault.present) {
      map['shared_bet_default'] = Variable<bool>(sharedBetDefault.value);
    }
    if (bestOneAmount.present) {
      map['best_one_amount'] = Variable<int>(bestOneAmount.value);
    }
    if (bestTwoAmount.present) {
      map['best_two_amount'] = Variable<int>(bestTwoAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameRuleSettingsTableCompanion(')
          ..write('gameId: $gameId, ')
          ..write('bestOneEnabled: $bestOneEnabled, ')
          ..write('bestTwoEnabled: $bestTwoEnabled, ')
          ..write('sharedBetDefault: $sharedBetDefault, ')
          ..write('bestOneAmount: $bestOneAmount, ')
          ..write('bestTwoAmount: $bestTwoAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoleConfigsTableTable extends HoleConfigsTable
    with TableInfo<$HoleConfigsTableTable, HoleConfigsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoleConfigsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _holeNumberMeta =
      const VerificationMeta('holeNumber');
  @override
  late final GeneratedColumn<int> holeNumber = GeneratedColumn<int>(
      'hole_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _parMeta = const VerificationMeta('par');
  @override
  late final GeneratedColumn<int> par = GeneratedColumn<int>(
      'par', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _isTurboMeta =
      const VerificationMeta('isTurbo');
  @override
  late final GeneratedColumn<bool> isTurbo = GeneratedColumn<bool>(
      'is_turbo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_turbo" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isBirdieBonusMeta =
      const VerificationMeta('isBirdieBonus');
  @override
  late final GeneratedColumn<bool> isBirdieBonus = GeneratedColumn<bool>(
      'is_birdie_bonus', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_birdie_bonus" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, gameId, holeNumber, par, isTurbo, isBirdieBonus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hole_configs_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<HoleConfigsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('hole_number')) {
      context.handle(
          _holeNumberMeta,
          holeNumber.isAcceptableOrUnknown(
              data['hole_number']!, _holeNumberMeta));
    } else if (isInserting) {
      context.missing(_holeNumberMeta);
    }
    if (data.containsKey('par')) {
      context.handle(
          _parMeta, par.isAcceptableOrUnknown(data['par']!, _parMeta));
    }
    if (data.containsKey('is_turbo')) {
      context.handle(_isTurboMeta,
          isTurbo.isAcceptableOrUnknown(data['is_turbo']!, _isTurboMeta));
    }
    if (data.containsKey('is_birdie_bonus')) {
      context.handle(
          _isBirdieBonusMeta,
          isBirdieBonus.isAcceptableOrUnknown(
              data['is_birdie_bonus']!, _isBirdieBonusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HoleConfigsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoleConfigsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      holeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hole_number'])!,
      par: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}par'])!,
      isTurbo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_turbo'])!,
      isBirdieBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_birdie_bonus'])!,
    );
  }

  @override
  $HoleConfigsTableTable createAlias(String alias) {
    return $HoleConfigsTableTable(attachedDatabase, alias);
  }
}

class HoleConfigsTableData extends DataClass
    implements Insertable<HoleConfigsTableData> {
  final String id;
  final String gameId;
  final int holeNumber;
  final int par;
  final bool isTurbo;
  final bool isBirdieBonus;
  const HoleConfigsTableData(
      {required this.id,
      required this.gameId,
      required this.holeNumber,
      required this.par,
      required this.isTurbo,
      required this.isBirdieBonus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['hole_number'] = Variable<int>(holeNumber);
    map['par'] = Variable<int>(par);
    map['is_turbo'] = Variable<bool>(isTurbo);
    map['is_birdie_bonus'] = Variable<bool>(isBirdieBonus);
    return map;
  }

  HoleConfigsTableCompanion toCompanion(bool nullToAbsent) {
    return HoleConfigsTableCompanion(
      id: Value(id),
      gameId: Value(gameId),
      holeNumber: Value(holeNumber),
      par: Value(par),
      isTurbo: Value(isTurbo),
      isBirdieBonus: Value(isBirdieBonus),
    );
  }

  factory HoleConfigsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoleConfigsTableData(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      holeNumber: serializer.fromJson<int>(json['holeNumber']),
      par: serializer.fromJson<int>(json['par']),
      isTurbo: serializer.fromJson<bool>(json['isTurbo']),
      isBirdieBonus: serializer.fromJson<bool>(json['isBirdieBonus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'holeNumber': serializer.toJson<int>(holeNumber),
      'par': serializer.toJson<int>(par),
      'isTurbo': serializer.toJson<bool>(isTurbo),
      'isBirdieBonus': serializer.toJson<bool>(isBirdieBonus),
    };
  }

  HoleConfigsTableData copyWith(
          {String? id,
          String? gameId,
          int? holeNumber,
          int? par,
          bool? isTurbo,
          bool? isBirdieBonus}) =>
      HoleConfigsTableData(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        holeNumber: holeNumber ?? this.holeNumber,
        par: par ?? this.par,
        isTurbo: isTurbo ?? this.isTurbo,
        isBirdieBonus: isBirdieBonus ?? this.isBirdieBonus,
      );
  HoleConfigsTableData copyWithCompanion(HoleConfigsTableCompanion data) {
    return HoleConfigsTableData(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      holeNumber:
          data.holeNumber.present ? data.holeNumber.value : this.holeNumber,
      par: data.par.present ? data.par.value : this.par,
      isTurbo: data.isTurbo.present ? data.isTurbo.value : this.isTurbo,
      isBirdieBonus: data.isBirdieBonus.present
          ? data.isBirdieBonus.value
          : this.isBirdieBonus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoleConfigsTableData(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('holeNumber: $holeNumber, ')
          ..write('par: $par, ')
          ..write('isTurbo: $isTurbo, ')
          ..write('isBirdieBonus: $isBirdieBonus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, holeNumber, par, isTurbo, isBirdieBonus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoleConfigsTableData &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.holeNumber == this.holeNumber &&
          other.par == this.par &&
          other.isTurbo == this.isTurbo &&
          other.isBirdieBonus == this.isBirdieBonus);
}

class HoleConfigsTableCompanion extends UpdateCompanion<HoleConfigsTableData> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<int> holeNumber;
  final Value<int> par;
  final Value<bool> isTurbo;
  final Value<bool> isBirdieBonus;
  final Value<int> rowid;
  const HoleConfigsTableCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.holeNumber = const Value.absent(),
    this.par = const Value.absent(),
    this.isTurbo = const Value.absent(),
    this.isBirdieBonus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoleConfigsTableCompanion.insert({
    required String id,
    required String gameId,
    required int holeNumber,
    this.par = const Value.absent(),
    this.isTurbo = const Value.absent(),
    this.isBirdieBonus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        gameId = Value(gameId),
        holeNumber = Value(holeNumber);
  static Insertable<HoleConfigsTableData> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<int>? holeNumber,
    Expression<int>? par,
    Expression<bool>? isTurbo,
    Expression<bool>? isBirdieBonus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (holeNumber != null) 'hole_number': holeNumber,
      if (par != null) 'par': par,
      if (isTurbo != null) 'is_turbo': isTurbo,
      if (isBirdieBonus != null) 'is_birdie_bonus': isBirdieBonus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoleConfigsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? gameId,
      Value<int>? holeNumber,
      Value<int>? par,
      Value<bool>? isTurbo,
      Value<bool>? isBirdieBonus,
      Value<int>? rowid}) {
    return HoleConfigsTableCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      holeNumber: holeNumber ?? this.holeNumber,
      par: par ?? this.par,
      isTurbo: isTurbo ?? this.isTurbo,
      isBirdieBonus: isBirdieBonus ?? this.isBirdieBonus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (holeNumber.present) {
      map['hole_number'] = Variable<int>(holeNumber.value);
    }
    if (par.present) {
      map['par'] = Variable<int>(par.value);
    }
    if (isTurbo.present) {
      map['is_turbo'] = Variable<bool>(isTurbo.value);
    }
    if (isBirdieBonus.present) {
      map['is_birdie_bonus'] = Variable<bool>(isBirdieBonus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoleConfigsTableCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('holeNumber: $holeNumber, ')
          ..write('par: $par, ')
          ..write('isTurbo: $isTurbo, ')
          ..write('isBirdieBonus: $isBirdieBonus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $GamesTableTable gamesTable = $GamesTableTable(this);
  late final $PlayersTableTable playersTable = $PlayersTableTable(this);
  late final $TeamsTableTable teamsTable = $TeamsTableTable(this);
  late final $GameRuleSettingsTableTable gameRuleSettingsTable =
      $GameRuleSettingsTableTable(this);
  late final $HoleConfigsTableTable holeConfigsTable =
      $HoleConfigsTableTable(this);
  late final AppSettingsDao appSettingsDao =
      AppSettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appSettingsTable,
        gamesTable,
        playersTable,
        teamsTable,
        gameRuleSettingsTable,
        holeConfigsTable
      ];
}

typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> languageCode,
  Value<String> currencyCode,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> languageCode,
  Value<String> currencyCode,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            languageCode: languageCode,
            currencyCode: currencyCode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            languageCode: languageCode,
            currencyCode: currencyCode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;
typedef $$GamesTableTableCreateCompanionBuilder = GamesTableCompanion Function({
  required String id,
  required String title,
  required String mode,
  Value<String> status,
  Value<int> totalHoles,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$GamesTableTableUpdateCompanionBuilder = GamesTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> mode,
  Value<String> status,
  Value<int> totalHoles,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GamesTableTableFilterComposer
    extends Composer<_$AppDatabase, $GamesTableTable> {
  $$GamesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHoles => $composableBuilder(
      column: $table.totalHoles, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GamesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTableTable> {
  $$GamesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHoles => $composableBuilder(
      column: $table.totalHoles, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GamesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTableTable> {
  $$GamesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalHoles => $composableBuilder(
      column: $table.totalHoles, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GamesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GamesTableTable,
    GamesTableData,
    $$GamesTableTableFilterComposer,
    $$GamesTableTableOrderingComposer,
    $$GamesTableTableAnnotationComposer,
    $$GamesTableTableCreateCompanionBuilder,
    $$GamesTableTableUpdateCompanionBuilder,
    (
      GamesTableData,
      BaseReferences<_$AppDatabase, $GamesTableTable, GamesTableData>
    ),
    GamesTableData,
    PrefetchHooks Function()> {
  $$GamesTableTableTableManager(_$AppDatabase db, $GamesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> totalHoles = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GamesTableCompanion(
            id: id,
            title: title,
            mode: mode,
            status: status,
            totalHoles: totalHoles,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String mode,
            Value<String> status = const Value.absent(),
            Value<int> totalHoles = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GamesTableCompanion.insert(
            id: id,
            title: title,
            mode: mode,
            status: status,
            totalHoles: totalHoles,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GamesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GamesTableTable,
    GamesTableData,
    $$GamesTableTableFilterComposer,
    $$GamesTableTableOrderingComposer,
    $$GamesTableTableAnnotationComposer,
    $$GamesTableTableCreateCompanionBuilder,
    $$GamesTableTableUpdateCompanionBuilder,
    (
      GamesTableData,
      BaseReferences<_$AppDatabase, $GamesTableTable, GamesTableData>
    ),
    GamesTableData,
    PrefetchHooks Function()>;
typedef $$PlayersTableTableCreateCompanionBuilder = PlayersTableCompanion
    Function({
  required String id,
  required String gameId,
  required String name,
  required int playerOrder,
  Value<String?> teamId,
  Value<int> rowid,
});
typedef $$PlayersTableTableUpdateCompanionBuilder = PlayersTableCompanion
    Function({
  Value<String> id,
  Value<String> gameId,
  Value<String> name,
  Value<int> playerOrder,
  Value<String?> teamId,
  Value<int> rowid,
});

class $$PlayersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerOrder => $composableBuilder(
      column: $table.playerOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get teamId => $composableBuilder(
      column: $table.teamId, builder: (column) => ColumnFilters(column));
}

class $$PlayersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerOrder => $composableBuilder(
      column: $table.playerOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get teamId => $composableBuilder(
      column: $table.teamId, builder: (column) => ColumnOrderings(column));
}

class $$PlayersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get playerOrder => $composableBuilder(
      column: $table.playerOrder, builder: (column) => column);

  GeneratedColumn<String> get teamId =>
      $composableBuilder(column: $table.teamId, builder: (column) => column);
}

class $$PlayersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayersTableTable,
    PlayersTableData,
    $$PlayersTableTableFilterComposer,
    $$PlayersTableTableOrderingComposer,
    $$PlayersTableTableAnnotationComposer,
    $$PlayersTableTableCreateCompanionBuilder,
    $$PlayersTableTableUpdateCompanionBuilder,
    (
      PlayersTableData,
      BaseReferences<_$AppDatabase, $PlayersTableTable, PlayersTableData>
    ),
    PlayersTableData,
    PrefetchHooks Function()> {
  $$PlayersTableTableTableManager(_$AppDatabase db, $PlayersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> playerOrder = const Value.absent(),
            Value<String?> teamId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayersTableCompanion(
            id: id,
            gameId: gameId,
            name: name,
            playerOrder: playerOrder,
            teamId: teamId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String gameId,
            required String name,
            required int playerOrder,
            Value<String?> teamId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayersTableCompanion.insert(
            id: id,
            gameId: gameId,
            name: name,
            playerOrder: playerOrder,
            teamId: teamId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlayersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayersTableTable,
    PlayersTableData,
    $$PlayersTableTableFilterComposer,
    $$PlayersTableTableOrderingComposer,
    $$PlayersTableTableAnnotationComposer,
    $$PlayersTableTableCreateCompanionBuilder,
    $$PlayersTableTableUpdateCompanionBuilder,
    (
      PlayersTableData,
      BaseReferences<_$AppDatabase, $PlayersTableTable, PlayersTableData>
    ),
    PlayersTableData,
    PrefetchHooks Function()>;
typedef $$TeamsTableTableCreateCompanionBuilder = TeamsTableCompanion Function({
  required String id,
  required String gameId,
  required String name,
  required int teamOrder,
  Value<int> rowid,
});
typedef $$TeamsTableTableUpdateCompanionBuilder = TeamsTableCompanion Function({
  Value<String> id,
  Value<String> gameId,
  Value<String> name,
  Value<int> teamOrder,
  Value<int> rowid,
});

class $$TeamsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get teamOrder => $composableBuilder(
      column: $table.teamOrder, builder: (column) => ColumnFilters(column));
}

class $$TeamsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get teamOrder => $composableBuilder(
      column: $table.teamOrder, builder: (column) => ColumnOrderings(column));
}

class $$TeamsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get teamOrder =>
      $composableBuilder(column: $table.teamOrder, builder: (column) => column);
}

class $$TeamsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TeamsTableTable,
    TeamsTableData,
    $$TeamsTableTableFilterComposer,
    $$TeamsTableTableOrderingComposer,
    $$TeamsTableTableAnnotationComposer,
    $$TeamsTableTableCreateCompanionBuilder,
    $$TeamsTableTableUpdateCompanionBuilder,
    (
      TeamsTableData,
      BaseReferences<_$AppDatabase, $TeamsTableTable, TeamsTableData>
    ),
    TeamsTableData,
    PrefetchHooks Function()> {
  $$TeamsTableTableTableManager(_$AppDatabase db, $TeamsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> teamOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeamsTableCompanion(
            id: id,
            gameId: gameId,
            name: name,
            teamOrder: teamOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String gameId,
            required String name,
            required int teamOrder,
            Value<int> rowid = const Value.absent(),
          }) =>
              TeamsTableCompanion.insert(
            id: id,
            gameId: gameId,
            name: name,
            teamOrder: teamOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TeamsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TeamsTableTable,
    TeamsTableData,
    $$TeamsTableTableFilterComposer,
    $$TeamsTableTableOrderingComposer,
    $$TeamsTableTableAnnotationComposer,
    $$TeamsTableTableCreateCompanionBuilder,
    $$TeamsTableTableUpdateCompanionBuilder,
    (
      TeamsTableData,
      BaseReferences<_$AppDatabase, $TeamsTableTable, TeamsTableData>
    ),
    TeamsTableData,
    PrefetchHooks Function()>;
typedef $$GameRuleSettingsTableTableCreateCompanionBuilder
    = GameRuleSettingsTableCompanion Function({
  required String gameId,
  Value<bool> bestOneEnabled,
  Value<bool> bestTwoEnabled,
  Value<bool> sharedBetDefault,
  Value<int?> bestOneAmount,
  Value<int?> bestTwoAmount,
  Value<int> rowid,
});
typedef $$GameRuleSettingsTableTableUpdateCompanionBuilder
    = GameRuleSettingsTableCompanion Function({
  Value<String> gameId,
  Value<bool> bestOneEnabled,
  Value<bool> bestTwoEnabled,
  Value<bool> sharedBetDefault,
  Value<int?> bestOneAmount,
  Value<int?> bestTwoAmount,
  Value<int> rowid,
});

class $$GameRuleSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GameRuleSettingsTableTable> {
  $$GameRuleSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bestOneEnabled => $composableBuilder(
      column: $table.bestOneEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bestTwoEnabled => $composableBuilder(
      column: $table.bestTwoEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sharedBetDefault => $composableBuilder(
      column: $table.sharedBetDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bestOneAmount => $composableBuilder(
      column: $table.bestOneAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bestTwoAmount => $composableBuilder(
      column: $table.bestTwoAmount, builder: (column) => ColumnFilters(column));
}

class $$GameRuleSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GameRuleSettingsTableTable> {
  $$GameRuleSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bestOneEnabled => $composableBuilder(
      column: $table.bestOneEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bestTwoEnabled => $composableBuilder(
      column: $table.bestTwoEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sharedBetDefault => $composableBuilder(
      column: $table.sharedBetDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bestOneAmount => $composableBuilder(
      column: $table.bestOneAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bestTwoAmount => $composableBuilder(
      column: $table.bestTwoAmount,
      builder: (column) => ColumnOrderings(column));
}

class $$GameRuleSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameRuleSettingsTableTable> {
  $$GameRuleSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<bool> get bestOneEnabled => $composableBuilder(
      column: $table.bestOneEnabled, builder: (column) => column);

  GeneratedColumn<bool> get bestTwoEnabled => $composableBuilder(
      column: $table.bestTwoEnabled, builder: (column) => column);

  GeneratedColumn<bool> get sharedBetDefault => $composableBuilder(
      column: $table.sharedBetDefault, builder: (column) => column);

  GeneratedColumn<int> get bestOneAmount => $composableBuilder(
      column: $table.bestOneAmount, builder: (column) => column);

  GeneratedColumn<int> get bestTwoAmount => $composableBuilder(
      column: $table.bestTwoAmount, builder: (column) => column);
}

class $$GameRuleSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameRuleSettingsTableTable,
    GameRuleSettingsTableData,
    $$GameRuleSettingsTableTableFilterComposer,
    $$GameRuleSettingsTableTableOrderingComposer,
    $$GameRuleSettingsTableTableAnnotationComposer,
    $$GameRuleSettingsTableTableCreateCompanionBuilder,
    $$GameRuleSettingsTableTableUpdateCompanionBuilder,
    (
      GameRuleSettingsTableData,
      BaseReferences<_$AppDatabase, $GameRuleSettingsTableTable,
          GameRuleSettingsTableData>
    ),
    GameRuleSettingsTableData,
    PrefetchHooks Function()> {
  $$GameRuleSettingsTableTableTableManager(
      _$AppDatabase db, $GameRuleSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameRuleSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$GameRuleSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameRuleSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> gameId = const Value.absent(),
            Value<bool> bestOneEnabled = const Value.absent(),
            Value<bool> bestTwoEnabled = const Value.absent(),
            Value<bool> sharedBetDefault = const Value.absent(),
            Value<int?> bestOneAmount = const Value.absent(),
            Value<int?> bestTwoAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameRuleSettingsTableCompanion(
            gameId: gameId,
            bestOneEnabled: bestOneEnabled,
            bestTwoEnabled: bestTwoEnabled,
            sharedBetDefault: sharedBetDefault,
            bestOneAmount: bestOneAmount,
            bestTwoAmount: bestTwoAmount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String gameId,
            Value<bool> bestOneEnabled = const Value.absent(),
            Value<bool> bestTwoEnabled = const Value.absent(),
            Value<bool> sharedBetDefault = const Value.absent(),
            Value<int?> bestOneAmount = const Value.absent(),
            Value<int?> bestTwoAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameRuleSettingsTableCompanion.insert(
            gameId: gameId,
            bestOneEnabled: bestOneEnabled,
            bestTwoEnabled: bestTwoEnabled,
            sharedBetDefault: sharedBetDefault,
            bestOneAmount: bestOneAmount,
            bestTwoAmount: bestTwoAmount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameRuleSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $GameRuleSettingsTableTable,
        GameRuleSettingsTableData,
        $$GameRuleSettingsTableTableFilterComposer,
        $$GameRuleSettingsTableTableOrderingComposer,
        $$GameRuleSettingsTableTableAnnotationComposer,
        $$GameRuleSettingsTableTableCreateCompanionBuilder,
        $$GameRuleSettingsTableTableUpdateCompanionBuilder,
        (
          GameRuleSettingsTableData,
          BaseReferences<_$AppDatabase, $GameRuleSettingsTableTable,
              GameRuleSettingsTableData>
        ),
        GameRuleSettingsTableData,
        PrefetchHooks Function()>;
typedef $$HoleConfigsTableTableCreateCompanionBuilder
    = HoleConfigsTableCompanion Function({
  required String id,
  required String gameId,
  required int holeNumber,
  Value<int> par,
  Value<bool> isTurbo,
  Value<bool> isBirdieBonus,
  Value<int> rowid,
});
typedef $$HoleConfigsTableTableUpdateCompanionBuilder
    = HoleConfigsTableCompanion Function({
  Value<String> id,
  Value<String> gameId,
  Value<int> holeNumber,
  Value<int> par,
  Value<bool> isTurbo,
  Value<bool> isBirdieBonus,
  Value<int> rowid,
});

class $$HoleConfigsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HoleConfigsTableTable> {
  $$HoleConfigsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holeNumber => $composableBuilder(
      column: $table.holeNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get par => $composableBuilder(
      column: $table.par, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTurbo => $composableBuilder(
      column: $table.isTurbo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBirdieBonus => $composableBuilder(
      column: $table.isBirdieBonus, builder: (column) => ColumnFilters(column));
}

class $$HoleConfigsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HoleConfigsTableTable> {
  $$HoleConfigsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holeNumber => $composableBuilder(
      column: $table.holeNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get par => $composableBuilder(
      column: $table.par, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTurbo => $composableBuilder(
      column: $table.isTurbo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBirdieBonus => $composableBuilder(
      column: $table.isBirdieBonus,
      builder: (column) => ColumnOrderings(column));
}

class $$HoleConfigsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoleConfigsTableTable> {
  $$HoleConfigsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<int> get holeNumber => $composableBuilder(
      column: $table.holeNumber, builder: (column) => column);

  GeneratedColumn<int> get par =>
      $composableBuilder(column: $table.par, builder: (column) => column);

  GeneratedColumn<bool> get isTurbo =>
      $composableBuilder(column: $table.isTurbo, builder: (column) => column);

  GeneratedColumn<bool> get isBirdieBonus => $composableBuilder(
      column: $table.isBirdieBonus, builder: (column) => column);
}

class $$HoleConfigsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HoleConfigsTableTable,
    HoleConfigsTableData,
    $$HoleConfigsTableTableFilterComposer,
    $$HoleConfigsTableTableOrderingComposer,
    $$HoleConfigsTableTableAnnotationComposer,
    $$HoleConfigsTableTableCreateCompanionBuilder,
    $$HoleConfigsTableTableUpdateCompanionBuilder,
    (
      HoleConfigsTableData,
      BaseReferences<_$AppDatabase, $HoleConfigsTableTable,
          HoleConfigsTableData>
    ),
    HoleConfigsTableData,
    PrefetchHooks Function()> {
  $$HoleConfigsTableTableTableManager(
      _$AppDatabase db, $HoleConfigsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoleConfigsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoleConfigsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoleConfigsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<int> holeNumber = const Value.absent(),
            Value<int> par = const Value.absent(),
            Value<bool> isTurbo = const Value.absent(),
            Value<bool> isBirdieBonus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HoleConfigsTableCompanion(
            id: id,
            gameId: gameId,
            holeNumber: holeNumber,
            par: par,
            isTurbo: isTurbo,
            isBirdieBonus: isBirdieBonus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String gameId,
            required int holeNumber,
            Value<int> par = const Value.absent(),
            Value<bool> isTurbo = const Value.absent(),
            Value<bool> isBirdieBonus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HoleConfigsTableCompanion.insert(
            id: id,
            gameId: gameId,
            holeNumber: holeNumber,
            par: par,
            isTurbo: isTurbo,
            isBirdieBonus: isBirdieBonus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HoleConfigsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HoleConfigsTableTable,
    HoleConfigsTableData,
    $$HoleConfigsTableTableFilterComposer,
    $$HoleConfigsTableTableOrderingComposer,
    $$HoleConfigsTableTableAnnotationComposer,
    $$HoleConfigsTableTableCreateCompanionBuilder,
    $$HoleConfigsTableTableUpdateCompanionBuilder,
    (
      HoleConfigsTableData,
      BaseReferences<_$AppDatabase, $HoleConfigsTableTable,
          HoleConfigsTableData>
    ),
    HoleConfigsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$GamesTableTableTableManager get gamesTable =>
      $$GamesTableTableTableManager(_db, _db.gamesTable);
  $$PlayersTableTableTableManager get playersTable =>
      $$PlayersTableTableTableManager(_db, _db.playersTable);
  $$TeamsTableTableTableManager get teamsTable =>
      $$TeamsTableTableTableManager(_db, _db.teamsTable);
  $$GameRuleSettingsTableTableTableManager get gameRuleSettingsTable =>
      $$GameRuleSettingsTableTableTableManager(_db, _db.gameRuleSettingsTable);
  $$HoleConfigsTableTableTableManager get holeConfigsTable =>
      $$HoleConfigsTableTableTableManager(_db, _db.holeConfigsTable);
}
