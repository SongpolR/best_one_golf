// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_dao.dart';

// ignore_for_file: type=lint
mixin _$GamesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTableTable get gamesTable => attachedDatabase.gamesTable;
  $PlayersTableTable get playersTable => attachedDatabase.playersTable;
  $TeamsTableTable get teamsTable => attachedDatabase.teamsTable;
  $GameRuleSettingsTableTable get gameRuleSettingsTable =>
      attachedDatabase.gameRuleSettingsTable;
  $HoleConfigsTableTable get holeConfigsTable =>
      attachedDatabase.holeConfigsTable;
  GamesDaoManager get managers => GamesDaoManager(this);
}

class GamesDaoManager {
  final _$GamesDaoMixin _db;
  GamesDaoManager(this._db);
  $$GamesTableTableTableManager get gamesTable =>
      $$GamesTableTableTableManager(_db.attachedDatabase, _db.gamesTable);
  $$PlayersTableTableTableManager get playersTable =>
      $$PlayersTableTableTableManager(_db.attachedDatabase, _db.playersTable);
  $$TeamsTableTableTableManager get teamsTable =>
      $$TeamsTableTableTableManager(_db.attachedDatabase, _db.teamsTable);
  $$GameRuleSettingsTableTableTableManager get gameRuleSettingsTable =>
      $$GameRuleSettingsTableTableTableManager(
          _db.attachedDatabase, _db.gameRuleSettingsTable);
  $$HoleConfigsTableTableTableManager get holeConfigsTable =>
      $$HoleConfigsTableTableTableManager(
          _db.attachedDatabase, _db.holeConfigsTable);
}
