import 'package:best_one_golf/domain/usecases/list_ongoing_games.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ListOngoingGamesUseCase returns ongoing games stream', () async {
    final repository = FakeGameRepository(
      ongoingGames: [
        fakeGameListItem(id: '1', title: 'Game 1'),
      ],
    );

    final useCase = ListOngoingGamesUseCase(repository);
    final result = await useCase().first;

    expect(result.length, 1);
    expect(result.first.title, 'Game 1');
  });
}
