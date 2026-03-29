import '../repositories/game_repository.dart';

class RecalculateGameUseCase {
  final GameRepository repository;

  const RecalculateGameUseCase(this.repository);

  Future<void> call(String gameId) {
    return repository.recalculateGame(gameId);
  }
}
