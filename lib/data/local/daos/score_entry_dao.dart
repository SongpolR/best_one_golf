import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_rule_settings_table.dart';
import '../tables/games_table.dart';
import '../tables/hole_configs_table.dart';
import '../tables/hole_scores_table.dart';
import '../tables/players_table.dart';
import '../tables/teams_table.dart';

part 'score_entry_dao.g.dart';

@DriftAccessor(
  tables: [
    GamesTable,
    PlayersTable,
    TeamsTable,
    GameRuleSettingsTable,
    HoleConfigsTable,
    HoleScoresTable,
  ],
)
class ScoreEntryDao extends DatabaseAccessor<AppDatabase>
    with _$ScoreEntryDaoMixin {
  ScoreEntryDao(super.db);

  Stream<GamesTableData> watchGame(String gameId) {
    return (select(gamesTable)..where((tbl) => tbl.id.equals(gameId)))
        .watchSingle();
  }

  Stream<List<PlayersTableData>> watchPlayers(String gameId) {
    return (select(playersTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.playerOrder),
          ]))
        .watch();
  }

  Stream<List<TeamsTableData>> watchTeams(String gameId) {
    return (select(teamsTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.teamOrder),
          ]))
        .watch();
  }

  Stream<GameRuleSettingsTableData> watchRuleSettings(String gameId) {
    return (select(gameRuleSettingsTable)
          ..where((tbl) => tbl.gameId.equals(gameId)))
        .watchSingle();
  }

  Stream<List<HoleConfigsTableData>> watchHoleConfigs(String gameId) {
    return (select(holeConfigsTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.holeNumber),
          ]))
        .watch();
  }

  Stream<List<HoleScoresTableData>> watchHoleScores(String gameId) {
    return (select(holeScoresTable)
          ..where((tbl) => tbl.gameId.equals(gameId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.holeNumber),
            (tbl) => OrderingTerm.asc(tbl.playerId),
          ]))
        .watch();
  }

  Future<void> updateScore({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  }) async {
    final existing = await (select(holeScoresTable)
          ..where((tbl) =>
              tbl.gameId.equals(gameId) &
              tbl.holeNumber.equals(holeNumber) &
              tbl.playerId.equals(playerId)))
        .getSingleOrNull();

    if (existing == null) {
      await into(holeScoresTable).insert(
        HoleScoresTableCompanion(
          id: Value('${gameId}_${holeNumber}_$playerId'),
          gameId: Value(gameId),
          holeNumber: Value(holeNumber),
          playerId: Value(playerId),
          strokes: Value(strokes),
        ),
      );
      return;
    }

    await (update(holeScoresTable)..where((tbl) => tbl.id.equals(existing.id)))
        .write(
      HoleScoresTableCompanion(
        strokes: Value(strokes),
      ),
    );
  }
}
