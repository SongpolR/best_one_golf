import 'package:best_one_golf/domain/usecases/duplicate_game.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DuplicateGameUseCase duplicates game and returns new game id',
      () async {
    final repository = FakeGameRepository();
    final useCase = DuplicateGameUseCase(repository);

    final newGameId = await useCase('game-1');

    expect(repository.duplicatedFromGameId, 'game-1');
    expect(newGameId, 'duplicated-game-1');
  });
}
