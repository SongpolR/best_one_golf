import '../repositories/game_repository.dart';

class RestartGameUseCase {
  final GameRepository repository;

  const RestartGameUseCase(this.repository);

  Future<String> call(String gameId) {
    return repository.restartGame(gameId);
  }
}
