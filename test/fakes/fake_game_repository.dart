import 'dart:async';

import 'package:best_one_golf/core/enums/game_mode.dart';
import 'package:best_one_golf/domain/entities/create_game_input.dart';
import 'package:best_one_golf/domain/entities/game.dart';
import 'package:best_one_golf/domain/entities/game_aggregate.dart';
import 'package:best_one_golf/domain/entities/game_list_item.dart';
import 'package:best_one_golf/domain/entities/game_rule_settings.dart';
import 'package:best_one_golf/domain/entities/hole_config.dart';
import 'package:best_one_golf/domain/entities/hole_score.dart';
import 'package:best_one_golf/domain/entities/player.dart';
import 'package:best_one_golf/domain/repositories/game_repository.dart';

class FakeGameRepository implements GameRepository {
  String createdGameId;
  CreateGameInput? lastInput;

  FakeGameRepository({
    this.createdGameId = 'test-game-123',
    List<GameListItem>? ongoingGames,
    List<GameListItem>? completedGames,
    GameAggregate? gameAggregate,
  })  : _ongoingGames = ongoingGames ?? [],
        _completedGames = completedGames ?? [],
        _gameAggregate = gameAggregate {
    _ongoingController.add(_ongoingGames);
    _completedController.add(_completedGames);
    if (_gameAggregate != null) {
      _gameAggregateController.add(_gameAggregate!);
    }
  }

  final StreamController<List<GameListItem>> _ongoingController =
      StreamController<List<GameListItem>>.broadcast();
  final StreamController<List<GameListItem>> _completedController =
      StreamController<List<GameListItem>>.broadcast();
  final StreamController<GameAggregate> _gameAggregateController =
      StreamController<GameAggregate>.broadcast();

  List<GameListItem> _ongoingGames;
  List<GameListItem> _completedGames;
  GameAggregate? _gameAggregate;

  String? deletedGameId;
  String? restartedFromGameId;
  String? finalizedGameId;

  @override
  Future<String> createGame(CreateGameInput input) async {
    lastInput = input;
    return createdGameId;
  }

  @override
  Stream<List<GameListItem>> watchOngoingGames() async* {
    yield _ongoingGames;
    yield* _ongoingController.stream;
  }

  @override
  Stream<List<GameListItem>> watchCompletedGames() async* {
    yield _completedGames;
    yield* _completedController.stream;
  }

  @override
  Stream<GameAggregate> watchGame(String gameId) async* {
    if (_gameAggregate != null) {
      yield _gameAggregate!;
    }
    yield* _gameAggregateController.stream;
  }

  @override
  Future<void> updateScore({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  }) async {
    if (_gameAggregate == null) return;

    final scores = [..._gameAggregate!.holeScores];
    final index = scores.indexWhere(
      (score) =>
          score.gameId == gameId &&
          score.holeNumber == holeNumber &&
          score.playerId == playerId,
    );

    if (index >= 0) {
      final existing = scores[index];
      scores[index] = HoleScore(
        id: existing.id,
        gameId: existing.gameId,
        holeNumber: existing.holeNumber,
        playerId: existing.playerId,
        strokes: strokes,
      );
    } else {
      scores.add(
        HoleScore(
          id: '${gameId}_${holeNumber}_$playerId',
          gameId: gameId,
          holeNumber: holeNumber,
          playerId: playerId,
          strokes: strokes,
        ),
      );
    }

    _gameAggregate = GameAggregate(
      game: _gameAggregate!.game,
      settings: _gameAggregate!.settings,
      players: _gameAggregate!.players,
      teams: _gameAggregate!.teams,
      holeConfigs: _gameAggregate!.holeConfigs,
      holeScores: scores,
    );

    _gameAggregateController.add(_gameAggregate!);
  }

  @override
  Future<void> deleteGame(String gameId) async {
    deletedGameId = gameId;
    _ongoingGames = _ongoingGames.where((game) => game.id != gameId).toList();
    _completedGames =
        _completedGames.where((game) => game.id != gameId).toList();

    _ongoingController.add(_ongoingGames);
    _completedController.add(_completedGames);
  }

  @override
  Future<void> finalizeGame(String gameId) async {
    finalizedGameId = gameId;

    final match = _ongoingGames.where((game) => game.id == gameId).toList();
    if (match.isNotEmpty) {
      final game = match.first;
      _ongoingGames = _ongoingGames.where((g) => g.id != gameId).toList();
      _completedGames = [
        GameListItem(
          id: game.id,
          title: game.title,
          mode: game.mode,
          status: 'completed',
          totalHoles: game.totalHoles,
          createdAt: game.createdAt,
          updatedAt: DateTime.now(),
        ),
        ..._completedGames,
      ];
      _ongoingController.add(_ongoingGames);
      _completedController.add(_completedGames);
    }
  }

  @override
  Future<String> restartGame(String gameId) async {
    restartedFromGameId = gameId;
    return 'restarted-$gameId';
  }

  Future<void> dispose() async {
    await _ongoingController.close();
    await _completedController.close();
    await _gameAggregateController.close();
  }
}

GameListItem fakeGameListItem({
  required String id,
  required String title,
  String status = 'ongoing',
  GameMode mode = GameMode.individual,
  int totalHoles = 18,
}) {
  final now = DateTime(2026, 1, 1);

  return GameListItem(
    id: id,
    title: title,
    mode: mode,
    status: status,
    totalHoles: totalHoles,
    createdAt: now,
    updatedAt: now,
  );
}

GameAggregate fakeGameAggregate({
  String gameId = 'game-1',
  String title = 'Saturday Match',
  int totalHoles = 18,
}) {
  return GameAggregate(
    game: Game(
      id: gameId,
      title: title,
      mode: GameMode.individual,
      status: 'ongoing',
      totalHoles: totalHoles,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    settings: const GameRuleSettings(
      gameId: 'game-1',
      bestOneEnabled: true,
      bestTwoEnabled: false,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
    ),
    players: const [
      Player(
        id: 'p1',
        gameId: 'game-1',
        name: 'Alice',
        order: 0,
        teamId: null,
      ),
      Player(
        id: 'p2',
        gameId: 'game-1',
        name: 'Bob',
        order: 1,
        teamId: null,
      ),
    ],
    teams: const [],
    holeConfigs: List.generate(
      18,
      (index) => HoleConfig(
        id: 'h${index + 1}',
        gameId: 'game-1',
        holeNumber: index + 1,
        par: 4,
        isTurbo: false,
        isBirdieBonus: false,
      ),
    ),
    holeScores: const [],
  );
}
