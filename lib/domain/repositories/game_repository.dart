import '../entities/create_game_input.dart';

abstract class GameRepository {
  Future<String> createGame(CreateGameInput input);
}
