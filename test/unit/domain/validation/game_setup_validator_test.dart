import 'package:best_one_golf/core/enums/game_mode.dart';
import 'package:best_one_golf/domain/services/validation/game_setup_validator.dart';
import 'package:best_one_golf/features/create_game/presentation/create_game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameSetupValidator', () {
    final validator = GameSetupValidator();

    CreateGameState validIndividualState() {
      return CreateGameState.initial().copyWith(
        title: 'Saturday Match',
        mode: GameMode.individual,
        players: const [
          PlayerDraft(name: 'A', order: 0, teamIndex: null),
          PlayerDraft(name: 'B', order: 1, teamIndex: null),
        ],
        bestOneEnabled: true,
        bestTwoEnabled: false,
        bestOneAmount: 20,
      );
    }

    test('returns invalid when title is empty', () {
      final result = validator.validate(
        validIndividualState().copyWith(title: ''),
      );

      expect(result.isValid, false);
    });

    test('returns invalid when player count is less than 2', () {
      final result = validator.validate(
        validIndividualState().copyWith(
          players: const [
            PlayerDraft(name: 'A', order: 0, teamIndex: null),
          ],
        ),
      );

      expect(result.isValid, false);
    });

    test('returns invalid when any player name is empty', () {
      final result = validator.validate(
        validIndividualState().copyWith(
          players: const [
            PlayerDraft(name: 'A', order: 0, teamIndex: null),
            PlayerDraft(name: '', order: 1, teamIndex: null),
          ],
        ),
      );

      expect(result.isValid, false);
    });

    test('returns invalid when no rules are enabled', () {
      final result = validator.validate(
        validIndividualState().copyWith(
          bestOneEnabled: false,
          bestTwoEnabled: false,
        ),
      );

      expect(result.isValid, false);
    });

    test('returns invalid when best one amount is not greater than zero', () {
      final result = validator.validate(
        validIndividualState().copyWith(
          bestOneAmount: 0,
        ),
      );

      expect(result.isValid, false);
    });

    test('returns valid for a correct individual game', () {
      final result = validator.validate(validIndividualState());

      expect(result.isValid, true);
    });

    test('returns invalid when team mode has unassigned players', () {
      final result = validator.validate(
        CreateGameState.initial().copyWith(
          title: 'Team Match',
          mode: GameMode.team,
          players: const [
            PlayerDraft(name: 'A', order: 0, teamIndex: 0),
            PlayerDraft(name: 'B', order: 1, teamIndex: null),
          ],
        ),
      );

      expect(result.isValid, false);
    });

    test(
        'returns invalid when best two enabled and a team has less than 2 players',
        () {
      final result = validator.validate(
        CreateGameState.initial().copyWith(
          title: 'Team Match',
          mode: GameMode.team,
          bestOneEnabled: true,
          bestTwoEnabled: true,
          bestOneAmount: 20,
          bestTwoAmount: 20,
          players: const [
            PlayerDraft(name: 'A', order: 0, teamIndex: 0),
            PlayerDraft(name: 'B', order: 1, teamIndex: 1),
          ],
        ),
      );

      expect(result.isValid, false);
    });

    test('returns valid for a correct team game with best two', () {
      final result = validator.validate(
        CreateGameState.initial().copyWith(
          title: 'Team Match',
          mode: GameMode.team,
          bestOneEnabled: true,
          bestTwoEnabled: true,
          bestOneAmount: 20,
          bestTwoAmount: 20,
          players: const [
            PlayerDraft(name: 'A', order: 0, teamIndex: 0),
            PlayerDraft(name: 'B', order: 1, teamIndex: 0),
            PlayerDraft(name: 'C', order: 2, teamIndex: 1),
            PlayerDraft(name: 'D', order: 3, teamIndex: 1),
          ],
        ),
      );

      expect(result.isValid, true);
    });
  });
}
