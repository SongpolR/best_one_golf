import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_rule_settings_table.dart';
import '../tables/games_table.dart';
import '../tables/hole_configs_table.dart';
import '../tables/players_table.dart';
import '../tables/teams_table.dart';

part 'games_dao.g.dart';

@DriftAccessor(
  tables: [
    GamesTable,
    PlayersTable,
    TeamsTable,
    GameRuleSettingsTable,
    HoleConfigsTable,
  ],
)
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  Future<void> insertGame({
    required GamesTableCompanion game,
    required List<PlayersTableCompanion> players,
    required List<TeamsTableCompanion> teams,
    required GameRuleSettingsTableCompanion ruleSettings,
    required List<HoleConfigsTableCompanion> holeConfigs,
  }) async {
    await transaction(() async {
      await into(gamesTable).insert(game);

      if (teams.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(teamsTable, teams);
        });
      }

      if (players.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(playersTable, players);
        });
      }

      await into(gameRuleSettingsTable).insert(ruleSettings);

      if (holeConfigs.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(holeConfigsTable, holeConfigs);
        });
      }
    });
  }
}
