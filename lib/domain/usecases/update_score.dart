import '../repositories/game_repository.dart';

class UpdateScoreUseCase {
  final GameRepository repository;

  const UpdateScoreUseCase(this.repository);

  Future<void> call({
    required String gameId,
    required int holeNumber,
    required String playerId,
    required int? strokes,
  }) {
    return repository.updateScore(
      gameId: gameId,
      holeNumber: holeNumber,
      playerId: playerId,
      strokes: strokes,
    );
  }
}
