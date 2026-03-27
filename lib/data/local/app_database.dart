import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/app_settings_dao.dart';
import 'daos/calculation_dao.dart';
import 'daos/games_dao.dart';
import 'daos/history_dao.dart';
import 'daos/score_entry_dao.dart';
import 'tables/app_settings_table.dart';
import 'tables/computed_hole_results_table.dart';
import 'tables/game_rule_settings_table.dart';
import 'tables/games_table.dart';
import 'tables/hole_configs_table.dart';
import 'tables/hole_scores_table.dart';
import 'tables/players_table.dart';
import 'tables/settlement_snapshots_table.dart';
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
    HoleScoresTable,
    ComputedHoleResultsTable,
    SettlementSnapshotsTable,
  ],
  daos: [
    AppSettingsDao,
    GamesDao,
    HistoryDao,
    ScoreEntryDao,
    CalculationDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          await m.createAll();
        },
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
