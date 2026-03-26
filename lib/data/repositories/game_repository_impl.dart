import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/enums/game_mode.dart';
import '../../domain/entities/create_game_input.dart';
import '../../domain/repositories/game_repository.dart';
import '../local/app_database.dart';

class GameRepositoryImpl implements GameRepository {
  final AppDatabase db;
  final Uuid uuid;

  GameRepositoryImpl(
    this.db, {
    Uuid? uuid,
  }) : uuid = uuid ?? const Uuid();

  @override
  Future<String> createGame(CreateGameInput input) async {
    final gameId = uuid.v4();
    final now = DateTime.now();

    final teamIdsByIndex = <int, String>{};

    final teamRows = <TeamsTableCompanion>[];
    for (var i = 0; i < input.teams.length; i++) {
      final teamInput = input.teams[i];
      final teamId = uuid.v4();
      teamIdsByIndex[i] = teamId;

      teamRows.add(
        TeamsTableCompanion(
          id: Value(teamId),
          gameId: Value(gameId),
          name: Value(teamInput.name),
          teamOrder: Value(teamInput.order),
        ),
      );
    }

    final playerRows = input.players.map((player) {
      final teamId =
          player.teamIndex != null ? teamIdsByIndex[player.teamIndex!] : null;

      return PlayersTableCompanion(
        id: Value(uuid.v4()),
        gameId: Value(gameId),
        name: Value(player.name),
        playerOrder: Value(player.order),
        teamId: Value(teamId),
      );
    }).toList();

    final holeRows = input.holes.map((hole) {
      return HoleConfigsTableCompanion(
        id: Value(uuid.v4()),
        gameId: Value(gameId),
        holeNumber: Value(hole.holeNumber),
        par: Value(hole.par),
        isTurbo: Value(hole.isTurbo),
        isBirdieBonus: Value(hole.isBirdieBonus),
      );
    }).toList();

    final gameRow = GamesTableCompanion(
      id: Value(gameId),
      title: Value(input.title),
      mode: Value(input.mode.value),
      status: const Value('ongoing'),
      totalHoles: Value(input.holes.length),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final ruleSettingsRow = GameRuleSettingsTableCompanion(
      gameId: Value(gameId),
      bestOneEnabled: Value(input.bestOneEnabled),
      bestTwoEnabled: Value(input.bestTwoEnabled),
      sharedBetDefault: Value(input.sharedBetDefault),
      bestOneAmount: Value(input.bestOneAmount),
      bestTwoAmount: Value(input.bestTwoAmount),
    );

    await db.gamesDao.insertGame(
      game: gameRow,
      players: playerRows,
      teams: input.mode == GameMode.team ? teamRows : const [],
      ruleSettings: ruleSettingsRow,
      holeConfigs: holeRows,
    );

    return gameId;
  }
}
