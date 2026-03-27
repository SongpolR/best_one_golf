import 'package:best_one_golf/domain/entities/create_game_input.dart';
import 'package:best_one_golf/domain/entities/game_list_item.dart';
import 'package:best_one_golf/domain/repositories/game_repository.dart';

class FakeGameRepository implements GameRepository {
  String createdGameId;
  CreateGameInput? lastInput;

  FakeGameRepository({
    this.createdGameId = 'test-game-123',
  });

  @override
  Future<String> createGame(CreateGameInput input) async {
    lastInput = input;
    return createdGameId;
  }

  @override
  Future<void> deleteGame(String gameId) {
    // TODO: implement deleteGame
    throw UnimplementedError();
  }

  @override
  Future<void> finalizeGame(String gameId) {
    // TODO: implement finalizeGame
    throw UnimplementedError();
  }

  @override
  Future<String> restartGame(String gameId) {
    // TODO: implement restartGame
    throw UnimplementedError();
  }

  @override
  Stream<List<GameListItem>> watchCompletedGames() {
    // TODO: implement watchCompletedGames
    throw UnimplementedError();
  }

  @override
  Stream<List<GameListItem>> watchOngoingGames() {
    // TODO: implement watchOngoingGames
    throw UnimplementedError();
  }
}
