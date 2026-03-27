import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_rule_settings_table.dart';
import '../tables/games_table.dart';
import '../tables/hole_configs_table.dart';
import '../tables/players_table.dart';
import '../tables/teams_table.dart';

part 'history_dao.g.dart';

@DriftAccessor(
  tables: [
    GamesTable,
    PlayersTable,
    TeamsTable,
    GameRuleSettingsTable,
    HoleConfigsTable,
  ],
)
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  Stream<List<GamesTableData>> watchGamesByStatus(String status) {
    return (select(gamesTable)
          ..where((tbl) => tbl.status.equals(status))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Future<void> deleteGame(String gameId) async {
    await transaction(() async {
      await (delete(holeConfigsTable)
            ..where((tbl) => tbl.gameId.equals(gameId)))
          .go();

      await (delete(gameRuleSettingsTable)
            ..where((tbl) => tbl.gameId.equals(gameId)))
          .go();

      await (delete(playersTable)..where((tbl) => tbl.gameId.equals(gameId)))
          .go();

      await (delete(teamsTable)..where((tbl) => tbl.gameId.equals(gameId)))
          .go();

      await (delete(gamesTable)..where((tbl) => tbl.id.equals(gameId))).go();
    });
  }

  Future<void> finalizeGame(String gameId) async {
    await (update(gamesTable)..where((tbl) => tbl.id.equals(gameId))).write(
      GamesTableCompanion(
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<GamesTableData> getGameById(String gameId) {
    return (select(gamesTable)..where((tbl) => tbl.id.equals(gameId)))
        .getSingle();
  }

  Future<List<PlayersTableData>> getPlayersByGameId(String gameId) {
    return (select(playersTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.playerOrder),
          ]))
        .get();
  }

  Future<List<TeamsTableData>> getTeamsByGameId(String gameId) {
    return (select(teamsTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.teamOrder),
          ]))
        .get();
  }

  Future<GameRuleSettingsTableData> getRuleSettingsByGameId(String gameId) {
    return (select(gameRuleSettingsTable)
          ..where((tbl) => tbl.gameId.equals(gameId)))
        .getSingle();
  }

  Future<List<HoleConfigsTableData>> getHoleConfigsByGameId(String gameId) {
    return (select(holeConfigsTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.holeNumber),
          ]))
        .get();
  }
}
