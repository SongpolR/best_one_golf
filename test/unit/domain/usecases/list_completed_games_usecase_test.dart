import 'package:best_one_golf/domain/usecases/list_completed_games.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ListCompletedGamesUseCase returns completed games stream', () async {
    final repository = FakeGameRepository(
      completedGames: [
        fakeGameListItem(
          id: '1',
          title: 'Completed Game',
          status: 'completed',
        ),
      ],
    );

    final useCase = ListCompletedGamesUseCase(repository);
    final result = await useCase().first;

    expect(result.length, 1);
    expect(result.first.title, 'Completed Game');
  });
}
