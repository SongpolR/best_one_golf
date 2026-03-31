import '../entities/create_game_input.dart';
import '../entities/game_aggregate.dart';
import '../entities/game_list_item.dart';

abstract class GameRepository {
  Future<String> createGame(CreateGameInput input);

  Stream<List<GameListItem>> watchOngoingGames();
  Stream<List<GameListItem>> watchCompletedGames();

  Stream<GameAggregate> watchGame(String gameId);

  Future<void> updateScore({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  });

  Future<void> recalculateGame(String gameId);

  Future<void> deleteGame(String gameId);
  Future<String> restartGame(String gameId);
  Future<String> duplicateGame(String gameId);
  Future<void> finalizeGame(String gameId);
}
