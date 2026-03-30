import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/game_mode.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/number_stepper.dart';
import 'create_game_controller.dart';
import 'create_game_state.dart';

class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key});

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  late final TextEditingController _titleController;
  final Map<int, TextEditingController> _playerControllers = {};
  final Map<int, TextEditingController> _teamControllers = {};
  late final TextEditingController _bestOneAmountController;
  late final TextEditingController _bestTwoAmountController;

  @override
  void initState() {
    super.initState();

    final state = ref.read(createGameControllerProvider);

    _titleController = TextEditingController(text: state.title);
    _bestOneAmountController = TextEditingController(
      text: state.bestOneAmount?.toString() ?? '',
    );
    _bestTwoAmountController = TextEditingController(
      text: state.bestTwoAmount?.toString() ?? '',
    );

    _syncPlayerControllers(state.players);
    _syncTeamControllers(state.teams);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bestOneAmountController.dispose();
    _bestTwoAmountController.dispose();

    for (final controller in _playerControllers.values) {
      controller.dispose();
    }

    for (final controller in _teamControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _syncPlayerControllers(List<PlayerDraft> players) {
    for (final player in players) {
      final existing = _playerControllers[player.order];
      if (existing == null) {
        _playerControllers[player.order] = TextEditingController(
          text: player.name,
        );
      } else if (existing.text != player.name) {
        existing.value = existing.value.copyWith(
          text: player.name,
          selection: TextSelection.collapsed(offset: player.name.length),
          composing: TextRange.empty,
        );
      }
    }

    final validKeys = players.map((e) => e.order).toSet();
    final toRemove = _playerControllers.keys
        .where((key) => !validKeys.contains(key))
        .toList();

    for (final key in toRemove) {
      _playerControllers[key]?.dispose();
      _playerControllers.remove(key);
    }
  }

  void _syncTeamControllers(List<TeamDraft> teams) {
    for (final team in teams) {
      final existing = _teamControllers[team.order];
      if (existing == null) {
        _teamControllers[team.order] = TextEditingController(
          text: team.name,
        );
      } else if (existing.text != team.name) {
        existing.value = existing.value.copyWith(
          text: team.name,
          selection: TextSelection.collapsed(offset: team.name.length),
          composing: TextRange.empty,
        );
      }
    }

    final validKeys = teams.map((e) => e.order).toSet();
    final toRemove =
        _teamControllers.keys.where((key) => !validKeys.contains(key)).toList();

    for (final key in toRemove) {
      _teamControllers[key]?.dispose();
      _teamControllers.remove(key);
    }
  }

  void _syncTopLevelControllers(CreateGameState state) {
    if (_titleController.text != state.title) {
      _titleController.value = _titleController.value.copyWith(
        text: state.title,
        selection: TextSelection.collapsed(offset: state.title.length),
        composing: TextRange.empty,
      );
    }

    final bestOneText = state.bestOneAmount?.toString() ?? '';
    if (_bestOneAmountController.text != bestOneText) {
      _bestOneAmountController.value = _bestOneAmountController.value.copyWith(
        text: bestOneText,
        selection: TextSelection.collapsed(offset: bestOneText.length),
        composing: TextRange.empty,
      );
    }

    final bestTwoText = state.bestTwoAmount?.toString() ?? '';
    if (_bestTwoAmountController.text != bestTwoText) {
      _bestTwoAmountController.value = _bestTwoAmountController.value.copyWith(
        text: bestTwoText,
        selection: TextSelection.collapsed(offset: bestTwoText.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createGameControllerProvider);
    final controller = ref.read(createGameControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    _syncTopLevelControllers(state);
    _syncPlayerControllers(state.players);
    _syncTeamControllers(state.teams);

    return AppScaffold(
      title: l10n.newGame,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('createGameTitleField'),
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.gameTitle,
            ),
            onChanged: controller.updateTitle,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.players,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...List.generate(state.players.length, (index) {
            final player = state.players[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _playerControllers[player.order],
                      decoration: InputDecoration(
                        labelText: l10n.playerN(index + 1),
                      ),
                      onChanged: (value) =>
                          controller.updatePlayerName(index, value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (state.mode == GameMode.team)
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: player.teamIndex,
                        decoration: InputDecoration(
                          labelText: l10n.team,
                        ),
                        items: List.generate(state.teams.length, (teamIndex) {
                          return DropdownMenuItem(
                            value: teamIndex,
                            child: Text(state.teams[teamIndex].name),
                          );
                        }),
                        onChanged: (value) =>
                            controller.updatePlayerTeam(index, value),
                      ),
                    ),
                  if (state.players.length > 2) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => controller.removePlayer(index),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              key: const Key('addPlayerButton'),
              onPressed: state.players.length < 6 ? controller.addPlayer : null,
              icon: const Icon(Icons.person_add),
              label: Text(l10n.addPlayer),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.mode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RadioListTile<GameMode>(
            key: const Key('individualModeRadio'),
            value: GameMode.individual,
            groupValue: state.mode,
            onChanged: (value) {
              if (value != null) controller.updateMode(value);
            },
            title: Text(l10n.individual),
          ),
          RadioListTile<GameMode>(
            key: const Key('teamModeRadio'),
            value: GameMode.team,
            groupValue: state.mode,
            onChanged: (value) {
              if (value != null) controller.updateMode(value);
            },
            title: Text(l10n.team),
          ),
          if (state.mode == GameMode.team) ...[
            const SizedBox(height: 16),
            Text(
              l10n.teams,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...List.generate(state.teams.length, (index) {
              final team = state.teams[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _teamControllers[team.order],
                  decoration: InputDecoration(
                    labelText: l10n.teamN(index + 1),
                  ),
                  onChanged: (value) => controller.updateTeamName(index, value),
                ),
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                key: const Key('addTeamButton'),
                onPressed: controller.addTeam,
                icon: const Icon(Icons.group_add),
                label: Text(l10n.addTeam),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.rules,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CheckboxListTile(
            value: state.bestOneEnabled,
            onChanged: (value) => controller.setBestOneEnabled(value ?? false),
            title: Text(l10n.bestOne),
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: state.bestTwoEnabled,
            onChanged: (value) => controller.setBestTwoEnabled(value ?? false),
            title: Text(l10n.bestTwo),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: state.sharedBetDefault,
            onChanged: controller.setSharedBetDefault,
            title: Text(l10n.useSameAmountForAllRules),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bestOneAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.bestOneAmount,
            ),
            onChanged: controller.updateBestOneAmount,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bestTwoAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: state.sharedBetDefault
                  ? l10n.bestTwoAmountOptional
                  : l10n.bestTwoAmount,
            ),
            onChanged: controller.updateBestTwoAmount,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.holeSetup,
            key: const Key('holeSetupSectionTitle'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: controller.applyTurboFor9And18,
                child: Text(l10n.setTurbo9And18),
              ),
              OutlinedButton(
                onPressed: controller.applyBirdieBonusFor9And18,
                child: Text(l10n.setBirdie9And18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(state.holes.length, (index) {
            final hole = state.holes[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.holeN(hole.holeNumber),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NumberStepper(
                      value: hole.par,
                      min: 3,
                      max: 5,
                      label: l10n.par,
                      onChanged: (v) => controller.updateHoleParInt(index, v!),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: hole.isTurbo,
                      onChanged: (value) =>
                          controller.updateHoleTurbo(index, value),
                      title: Text(l10n.turboX2),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      value: hole.isBirdieBonus,
                      onChanged: (value) =>
                          controller.updateHoleBirdieBonus(index, value),
                      title: Text(l10n.birdieBonusX2),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            );
          }),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('startGameButton'),
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final gameId = await controller.submit(ref);
                    if (gameId != null && context.mounted) {
                      context.go('/score-entry/$gameId');
                    }
                  },
            child: state.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.startGame),
          ),
        ],
      ),
    );
  }
}
