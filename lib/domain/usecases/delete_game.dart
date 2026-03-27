import '../repositories/game_repository.dart';

class DeleteGameUseCase {
  final GameRepository repository;

  const DeleteGameUseCase(this.repository);

  Future<void> call(String gameId) {
    return repository.deleteGame(gameId);
  }
}
