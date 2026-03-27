import '../entities/game_list_item.dart';
import '../repositories/game_repository.dart';

class ListCompletedGamesUseCase {
  final GameRepository repository;

  const ListCompletedGamesUseCase(this.repository);

  Stream<List<GameListItem>> call() {
    return repository.watchCompletedGames();
  }
}
