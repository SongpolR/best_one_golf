import 'package:best_one_golf/domain/entities/create_game_input.dart';
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
}
