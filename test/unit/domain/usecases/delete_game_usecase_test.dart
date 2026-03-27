import 'package:best_one_golf/domain/usecases/delete_game.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DeleteGameUseCase deletes game', () async {
    final repository = FakeGameRepository();
    final useCase = DeleteGameUseCase(repository);

    await useCase('game-1');

    expect(repository.deletedGameId, 'game-1');
  });
}
