import '../entities/create_game_input.dart';
import '../repositories/game_repository.dart';

class CreateGameUseCase {
  final GameRepository repository;

  const CreateGameUseCase(this.repository);

  Future<String> call(CreateGameInput input) {
    return repository.createGame(input);
  }
}
