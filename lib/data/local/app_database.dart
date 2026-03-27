import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/app_settings_dao.dart';
import 'daos/games_dao.dart';
import 'daos/history_dao.dart';
import 'tables/app_settings_table.dart';
import 'tables/game_rule_settings_table.dart';
import 'tables/games_table.dart';
import 'tables/hole_configs_table.dart';
import 'tables/players_table.dart';
import 'tables/teams_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AppSettingsTable,
    GamesTable,
    PlayersTable,
    TeamsTable,
    GameRuleSettingsTable,
    HoleConfigsTable,
  ],
  daos: [
    AppSettingsDao,
    GamesDao,
    HistoryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await appSettingsDao.ensureSeeded();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'bestone_golf.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
