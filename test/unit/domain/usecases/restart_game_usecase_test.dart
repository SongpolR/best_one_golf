import 'package:best_one_golf/domain/usecases/restart_game.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestartGameUseCase restarts game by clearing scores', () async {
    final repository = FakeGameRepository();
    final useCase = RestartGameUseCase(repository);

    await useCase('game-1');

    expect(repository.restartedFromGameId, 'game-1');
  });
}
