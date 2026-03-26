import '../../../core/enums/game_mode.dart';
import '../../../features/create_game/presentation/create_game_state.dart';

class ValidationResult {
  final bool isValid;
  final String? message;

  const ValidationResult({
    required this.isValid,
    this.message,
  });

  factory ValidationResult.valid() {
    return const ValidationResult(isValid: true);
  }

  factory ValidationResult.invalid(String message) {
    return ValidationResult(isValid: false, message: message);
  }
}

class GameSetupValidator {
  ValidationResult validate(CreateGameState state) {
    if (state.title.trim().isEmpty) {
      return ValidationResult.invalid('Game title is required.');
    }

    if (state.players.length < 2 || state.players.length > 6) {
      return ValidationResult.invalid('Players must be between 2 and 6.');
    }

    final hasEmptyPlayerName = state.players.any((p) => p.name.trim().isEmpty);
    if (hasEmptyPlayerName) {
      return ValidationResult.invalid('All player names are required.');
    }

    if (!state.bestOneEnabled && !state.bestTwoEnabled) {
      return ValidationResult.invalid(
        'At least one rule must be enabled.',
      );
    }

    if (state.bestOneEnabled) {
      final amount = state.bestOneAmount;
      if (amount == null || amount <= 0) {
        return ValidationResult.invalid(
          'Best One amount must be greater than zero.',
        );
      }
    }

    if (state.bestTwoEnabled) {
      final amount = state.bestTwoAmount;
      if (amount == null || amount <= 0) {
        return ValidationResult.invalid(
          'Best Two amount must be greater than zero.',
        );
      }
    }

    final hasInvalidPar = state.holes.any((hole) => hole.par <= 0);
    if (hasInvalidPar) {
      return ValidationResult.invalid(
          'All holes must have par greater than zero.');
    }

    if (state.mode == GameMode.team) {
      if (state.teams.length < 2) {
        return ValidationResult.invalid('At least 2 teams are required.');
      }

      final hasUnassignedPlayer = state.players.any((p) => p.teamIndex == null);
      if (hasUnassignedPlayer) {
        return ValidationResult.invalid(
            'All players must be assigned to a team.');
      }

      final teamCounts = <int, int>{};
      for (final player in state.players) {
        final teamIndex = player.teamIndex;
        if (teamIndex == null) continue;
        teamCounts[teamIndex] = (teamCounts[teamIndex] ?? 0) + 1;
      }

      if (state.bestTwoEnabled) {
        for (var index = 0; index < state.teams.length; index++) {
          final count = teamCounts[index] ?? 0;
          if (count < 2) {
            return ValidationResult.invalid(
              'Each team must have at least 2 players when Best Two is enabled.',
            );
          }
        }
      }
    }

    return ValidationResult.valid();
  }
}
