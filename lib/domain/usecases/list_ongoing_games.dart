import '../entities/game_list_item.dart';
import '../repositories/game_repository.dart';

class ListOngoingGamesUseCase {
  final GameRepository repository;

  const ListOngoingGamesUseCase(this.repository);

  Stream<List<GameListItem>> call() {
    return repository.watchOngoingGames();
  }
}
