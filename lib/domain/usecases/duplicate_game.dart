import '../repositories/game_repository.dart';

class DuplicateGameUseCase {
  final GameRepository repository;

  const DuplicateGameUseCase(this.repository);

  Future<String> call(String gameId) {
    return repository.duplicateGame(gameId);
  }
}
