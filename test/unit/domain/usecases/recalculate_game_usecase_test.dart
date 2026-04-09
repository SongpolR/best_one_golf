import 'package:best_one_golf/domain/usecases/recalculate_game.dart';
import '../../../fakes/fake_recalculate_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RecalculateGameUseCase calls repository recalculateGame', () async {
    final repository = FakeRecalculateGameRepository();
    final useCase = RecalculateGameUseCase(repository);

    await useCase('game-1');

    expect(repository.recalculatedGameId, 'game-1');
  });
}
