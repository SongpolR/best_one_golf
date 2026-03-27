import '../repositories/game_repository.dart';

class FinalizeGameUseCase {
  final GameRepository repository;

  const FinalizeGameUseCase(this.repository);

  Future<void> call(String gameId) {
    return repository.finalizeGame(gameId);
  }
}
