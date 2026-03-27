import '../entities/create_game_input.dart';
import '../entities/game_list_item.dart';

abstract class GameRepository {
  Future<String> createGame(CreateGameInput input);

  Stream<List<GameListItem>> watchOngoingGames();
  Stream<List<GameListItem>> watchCompletedGames();

  Future<void> deleteGame(String gameId);
  Future<String> restartGame(String gameId);
  Future<void> finalizeGame(String gameId);
}
