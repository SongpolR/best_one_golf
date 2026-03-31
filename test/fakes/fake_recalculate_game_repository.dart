import 'package:best_one_golf/domain/entities/create_game_input.dart';
import 'package:best_one_golf/domain/entities/game_aggregate.dart';
import 'package:best_one_golf/domain/entities/game_list_item.dart';
import 'package:best_one_golf/domain/repositories/game_repository.dart';

class FakeRecalculateGameRepository implements GameRepository {
  String? recalculatedGameId;

  @override
  Future<void> recalculateGame(String gameId) async {
    recalculatedGameId = gameId;
  }

  @override
  Future<String> createGame(CreateGameInput input) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<void> finalizeGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<String> restartGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<String> duplicateGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateScore({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<GameListItem>> watchCompletedGames() {
    throw UnimplementedError();
  }

  @override
  Stream<GameAggregate> watchGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Stream<List<GameListItem>> watchOngoingGames() {
    throw UnimplementedError();
  }
}
