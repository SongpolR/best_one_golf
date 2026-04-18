import '../repositories/game_repository.dart';

class RestartGameUseCase {
  final GameRepository repository;

  const RestartGameUseCase(this.repository);

  Future<void> call(String gameId) {
    return repository.restartGame(gameId);
  }
}
