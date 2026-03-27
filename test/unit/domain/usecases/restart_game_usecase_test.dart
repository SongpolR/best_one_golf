import 'package:best_one_golf/domain/usecases/restart_game.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestartGameUseCase restarts game and returns new game id', () async {
    final repository = FakeGameRepository();
    final useCase = RestartGameUseCase(repository);

    final newGameId = await useCase('game-1');

    expect(repository.restartedFromGameId, 'game-1');
    expect(newGameId, 'restarted-game-1');
  });
}
