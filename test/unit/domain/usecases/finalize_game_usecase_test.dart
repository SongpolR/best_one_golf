import 'package:best_one_golf/domain/usecases/finalize_game.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FinalizeGameUseCase finalizes game', () async {
    final repository = FakeGameRepository();
    final useCase = FinalizeGameUseCase(repository);

    await useCase('game-1');

    expect(repository.finalizedGameId, 'game-1');
  });
}
