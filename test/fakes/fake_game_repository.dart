import 'dart:async';

import 'package:best_one_golf/core/enums/game_mode.dart';
import 'package:best_one_golf/domain/entities/create_game_input.dart';
import 'package:best_one_golf/domain/entities/game_list_item.dart';
import 'package:best_one_golf/domain/repositories/game_repository.dart';

class FakeGameRepository implements GameRepository {
  String createdGameId;
  CreateGameInput? lastInput;

  FakeGameRepository({
    this.createdGameId = 'test-game-123',
    List<GameListItem>? ongoingGames,
    List<GameListItem>? completedGames,
  })  : _ongoingGames = ongoingGames ?? [],
        _completedGames = completedGames ?? [] {
    _ongoingController.add(_ongoingGames);
    _completedController.add(_completedGames);
  }

  final StreamController<List<GameListItem>> _ongoingController =
      StreamController<List<GameListItem>>.broadcast();
  final StreamController<List<GameListItem>> _completedController =
      StreamController<List<GameListItem>>.broadcast();

  List<GameListItem> _ongoingGames;
  List<GameListItem> _completedGames;

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
