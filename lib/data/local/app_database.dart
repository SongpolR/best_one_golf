import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/app_settings_dao.dart';
import 'daos/calculation_dao.dart';
import 'daos/games_dao.dart';
import 'daos/history_dao.dart';
import 'daos/result_view_dao.dart';
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
    ResultViewDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(gamesTable);
            await m.createTable(playersTable);
            await m.createTable(teamsTable);
            await m.createTable(gameRuleSettingsTable);
            await m.createTable(holeConfigsTable);
          }

          if (from < 3) {
            await m.createTable(holeScoresTable);
          }

          if (from < 4) {
            await m.createTable(computedHoleResultsTable);
            await m.createTable(settlementSnapshotsTable);
          }

          if (from < 5) {
            final hasThemeModeCode = await _hasColumn(
              appSettingsTable.actualTableName,
              'theme_mode_code',
            );

            if (!hasThemeModeCode) {
              await m.addColumn(
                appSettingsTable,
                appSettingsTable.themeModeCode,
              );
            }
          }

          if (from < 6) {
            final hasAdsRemoved = await _hasColumn(
              appSettingsTable.actualTableName,
              'ads_removed',
            );

            if (!hasAdsRemoved) {
              await m.addColumn(
                appSettingsTable,
                appSettingsTable.adsRemoved,
              );
            }
          }
        },
        beforeOpen: (details) async {
          await appSettingsDao.ensureSeeded();

          final hasThemeModeCode = await _hasColumn(
            appSettingsTable.actualTableName,
            'theme_mode_code',
          );

          if (hasThemeModeCode) {
            await customStatement(
              'UPDATE ${appSettingsTable.actualTableName} '
              "SET theme_mode_code = 'system' "
              'WHERE theme_mode_code IS NULL',
            );
          }

          final hasAdsRemoved = await _hasColumn(
            appSettingsTable.actualTableName,
            'ads_removed',
          );

          if (hasAdsRemoved) {
            await customStatement(
              'UPDATE ${appSettingsTable.actualTableName} '
              'SET ads_removed = 0 '
              'WHERE ads_removed IS NULL',
            );
          }
        },
      );

  Future<bool> _hasColumn(String tableName, String columnName) async {
    final result = await customSelect(
      'PRAGMA table_info("$tableName")',
    ).get();

    for (final row in result) {
      final name = row.read<String>('name');
      if (name == columnName) {
        return true;
      }
    }

    return false;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'best_one_golf.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
