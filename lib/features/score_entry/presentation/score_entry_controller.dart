import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/hole_state.dart';
import '../../../domain/entities/game_aggregate.dart';
import '../../../domain/usecases/load_game.dart';
import '../../../domain/usecases/update_score.dart';

final loadGameUseCaseProvider = Provider<LoadGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return LoadGameUseCase(repository);
});

final updateScoreUseCaseProvider = Provider<UpdateScoreUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return UpdateScoreUseCase(repository);
});

final selectedHoleProvider = StateProvider<int>((ref) => 1);

final gameAggregateProvider =
    StreamProvider.family<GameAggregate, String>((ref, gameId) {
  return ref.watch(loadGameUseCaseProvider).call(gameId);
});

class ScoreEntryController {
  final Ref ref;

  ScoreEntryController(this.ref);

  void nextHole(GameAggregate aggregate) {
    final current = ref.read(selectedHoleProvider);
    if (current < aggregate.game.totalHoles) {
      ref.read(selectedHoleProvider.notifier).state = current + 1;
    }
  }

  void previousHole() {
    final current = ref.read(selectedHoleProvider);
    if (current > 1) {
      ref.read(selectedHoleProvider.notifier).state = current - 1;
    }
  }

  void jumpToHole(int holeNumber) {
    ref.read(selectedHoleProvider.notifier).state = holeNumber;
  }

  void jumpToFirstIncompleteHole(GameAggregate aggregate) {
    for (var i = 1; i <= aggregate.game.totalHoles; i++) {
      if (getHoleState(aggregate: aggregate, holeNumber: i) !=
          HoleState.complete) {
        ref.read(selectedHoleProvider.notifier).state = i;
        return;
      }
    }
  }

  Future<void> updateScore({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required String value,
  }) async {
    final parsed = value.trim().isEmpty ? null : int.tryParse(value);

    await ref.read(updateScoreUseCaseProvider).call(
          gameId: gameId,
          holeNumber: holeNumber,
          playerId: playerId,
          strokes: parsed,
        );
  }

  Future<void> updateScoreInt({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  }) async {
    await ref.read(updateScoreUseCaseProvider).call(
          gameId: gameId,
          holeNumber: holeNumber,
          playerId: playerId,
          strokes: strokes,
        );
  }

  HoleState getHoleState({
    required GameAggregate aggregate,
    required int holeNumber,
  }) {
    final scores = aggregate.holeScores
        .where((score) => score.holeNumber == holeNumber)
        .toList();

    if (scores.isEmpty) return HoleState.empty;

    final filledCount = scores.where((score) => score.strokes != null).length;

    if (filledCount == 0) return HoleState.empty;
    if (filledCount < aggregate.players.length) return HoleState.partial;
    return HoleState.complete;
  }
}

final scoreEntryControllerProvider = Provider((ref) {
  return ScoreEntryController(ref);
});
