import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/game_mode.dart';
import '../../../domain/entities/create_game_input.dart';
import '../../../domain/entities/game_aggregate.dart';
import '../../../domain/services/validation/game_setup_validator.dart';
import 'create_game_state.dart';

final gameSetupValidatorProvider = Provider<GameSetupValidator>((ref) {
  return GameSetupValidator();
});

final createGameControllerProvider =
    AutoDisposeNotifierProvider<CreateGameController, CreateGameState>(
  CreateGameController.new,
);

class CreateGameController extends AutoDisposeNotifier<CreateGameState> {
  @override
  CreateGameState build() {
    return CreateGameState.initial();
  }

  void loadFromAggregate(GameAggregate aggregate) {
    state = CreateGameState.fromAggregate(aggregate);
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value, errorMessage: null);
  }

  void updateMode(GameMode mode) {
    state = state.copyWith(
      mode: mode,
      errorMessage: null,
      // Best One is always on; reset Best Two and amounts when switching to Individual.
      bestOneEnabled: true,
      bestTwoEnabled:
          mode == GameMode.individual ? false : state.bestTwoEnabled,
      sharedBetDefault:
          mode == GameMode.individual ? true : state.sharedBetDefault,
      players: mode == GameMode.individual
          ? state.players
              .map((player) => player.copyWith(teamIndex: null))
              .toList()
          : state.players,
    );
  }

  /// Toggles whether Team mode uses a separate amount per rule.
  /// When [useSeparate] is true: show Best One + Best Two fields individually.
  /// When false: show a single shared amount (Best Two disabled).
  void setUseSeparateAmounts(bool useSeparate) {
    state = state.copyWith(
      sharedBetDefault: !useSeparate,
      bestTwoEnabled: useSeparate,
      errorMessage: null,
    );
  }

  void addPlayer() {
    if (state.players.length >= 6) return;

    final updatedPlayers = [...state.players];
    updatedPlayers.add(
      PlayerDraft(
        name: '',
        order: updatedPlayers.length,
        teamIndex: null,
      ),
    );

    state = state.copyWith(players: updatedPlayers, errorMessage: null);
  }

  void removePlayer(int index) {
    if (state.players.length <= 2) return;

    final updatedPlayers = [...state.players]..removeAt(index);

    final normalized = <PlayerDraft>[];
    for (var i = 0; i < updatedPlayers.length; i++) {
      normalized.add(
        updatedPlayers[i].copyWith(order: i),
      );
    }

    state = state.copyWith(players: normalized, errorMessage: null);
  }

  void updatePlayerName(int index, String name) {
    final updatedPlayers = [...state.players];
    updatedPlayers[index] = updatedPlayers[index].copyWith(name: name);

    state = state.copyWith(players: updatedPlayers, errorMessage: null);
  }

  void updatePlayerTeam(int index, int? teamIndex) {
    final updatedPlayers = [...state.players];
    updatedPlayers[index] =
        updatedPlayers[index].copyWith(teamIndex: teamIndex);

    state = state.copyWith(players: updatedPlayers, errorMessage: null);
  }

  void addTeam() {
    if (state.teams.length >= 6) return;

    final updatedTeams = [...state.teams];
    final name = 'Team ${String.fromCharCode(65 + updatedTeams.length)}';

    updatedTeams.add(
      TeamDraft(
        name: name,
        order: updatedTeams.length,
      ),
    );

    state = state.copyWith(teams: updatedTeams, errorMessage: null);
  }

  void removeTeam(int index) {
    if (state.teams.length <= 2) return;

    final updatedTeams = [...state.teams]..removeAt(index);

    // Renormalize team orders.
    final normalizedTeams = <TeamDraft>[];
    for (var i = 0; i < updatedTeams.length; i++) {
      normalizedTeams.add(updatedTeams[i].copyWith(order: i));
    }

    // Reassign players: removed team → 0, shift higher indices down.
    final updatedPlayers = state.players.map((p) {
      if (p.teamIndex == null) return p;
      if (p.teamIndex == index) return p.copyWith(teamIndex: 0);
      if (p.teamIndex! > index) return p.copyWith(teamIndex: p.teamIndex! - 1);
      return p;
    }).toList();

    state = state.copyWith(
      teams: normalizedTeams,
      players: updatedPlayers,
      errorMessage: null,
    );
  }

  void updateTeamName(int index, String name) {
    final updatedTeams = [...state.teams];
    updatedTeams[index] = updatedTeams[index].copyWith(name: name);

    state = state.copyWith(teams: updatedTeams, errorMessage: null);
  }

  void setBestOneEnabled(bool value) {
    state = state.copyWith(bestOneEnabled: value, errorMessage: null);
  }

  void setBestTwoEnabled(bool value) {
    state = state.copyWith(bestTwoEnabled: value, errorMessage: null);
  }

  void setSharedBetDefault(bool value) {
    state = state.copyWith(sharedBetDefault: value, errorMessage: null);
  }

  void updateBestOneAmount(String value) {
    state = state.copyWith(
      bestOneAmount: int.tryParse(value),
      errorMessage: null,
    );
  }

  void updateBestTwoAmount(String value) {
    state = state.copyWith(
      bestTwoAmount: int.tryParse(value),
      errorMessage: null,
    );
  }

  void updateHolePar(int holeIndex, String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;

    final updatedHoles = [...state.holes];
    updatedHoles[holeIndex] = updatedHoles[holeIndex].copyWith(par: parsed);

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  void updateHoleParInt(int holeIndex, int par) {
    final updatedHoles = [...state.holes];
    updatedHoles[holeIndex] = updatedHoles[holeIndex].copyWith(par: par);

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  void updateHoleTurbo(int holeIndex, bool value) {
    final updatedHoles = [...state.holes];
    updatedHoles[holeIndex] = updatedHoles[holeIndex].copyWith(isTurbo: value);

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  void updateHoleBirdieBonus(int holeIndex, bool value) {
    final updatedHoles = [...state.holes];
    updatedHoles[holeIndex] =
        updatedHoles[holeIndex].copyWith(isBirdieBonus: value);

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  void applyTurboFor9And18() {
    final updatedHoles = [...state.holes];
    for (final target in [8, 17]) {
      updatedHoles[target] = updatedHoles[target].copyWith(isTurbo: true);
    }

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  void applyBirdieBonusFor9And18() {
    final updatedHoles = [...state.holes];
    for (final target in [8, 17]) {
      updatedHoles[target] = updatedHoles[target].copyWith(isBirdieBonus: true);
    }

    state = state.copyWith(holes: updatedHoles, errorMessage: null);
  }

  Future<String?> submit(WidgetRef ref) async {
    final validator = ref.read(gameSetupValidatorProvider);
    final validationResult = validator.validate(state);

    if (!validationResult.isValid) {
      state = state.copyWith(errorMessage: validationResult.message);
      return null;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final createGame = ref.read(createGameUseCaseProvider);

      final input = CreateGameInput(
        title: state.title.trim(),
        mode: state.mode,
        players: state.players
            .map(
              (player) => CreateGamePlayerInput(
                name: player.name.trim(),
                order: player.order,
                teamIndex: player.teamIndex,
              ),
            )
            .toList(),
        teams: state.teams
            .map(
              (team) => CreateGameTeamInput(
                name: team.name.trim(),
                order: team.order,
              ),
            )
            .toList(),
        bestOneEnabled: state.bestOneEnabled,
        bestTwoEnabled: state.bestTwoEnabled,
        sharedBetDefault: state.sharedBetDefault,
        bestOneAmount: state.bestOneAmount,
        bestTwoAmount: state.bestTwoAmount,
        holes: state.holes
            .map(
              (hole) => CreateGameHoleInput(
                holeNumber: hole.holeNumber,
                par: hole.par,
                isTurbo: hole.isTurbo,
                isBirdieBonus: hole.isBirdieBonus,
              ),
            )
            .toList(),
      );

      final gameId = await createGame(input);

      state = state.copyWith(isSubmitting: false);
      return gameId;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to create game: $e',
      );
      return null;
    }
  }
}
