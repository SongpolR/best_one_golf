import '../entities/game_aggregate.dart';
import '../repositories/game_repository.dart';

class LoadGameUseCase {
  final GameRepository repository;

  const LoadGameUseCase(this.repository);

  Stream<GameAggregate> call(String gameId) {
    return repository.watchGame(gameId);
  }
}
