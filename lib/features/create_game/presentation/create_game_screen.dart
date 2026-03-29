import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/game_mode.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import 'create_game_controller.dart';

class CreateGameScreen extends ConsumerWidget {
  const CreateGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createGameControllerProvider);
    final controller = ref.read(createGameControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.newGame,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('createGameTitleField'),
            decoration: const InputDecoration(
              labelText: 'Game Title',
            ),
            onChanged: controller.updateTitle,
          ),
          const SizedBox(height: 24),
          Text(
            'Players',
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
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
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
                        decoration: const InputDecoration(
                          labelText: 'Team',
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
              label: const Text('Add Player'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Mode',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RadioListTile<GameMode>(
            key: const Key('individualModeRadio'),
            value: GameMode.individual,
            groupValue: state.mode,
            onChanged: (value) {
              if (value != null) controller.updateMode(value);
            },
            title: const Text('Individual'),
          ),
          RadioListTile<GameMode>(
            key: const Key('teamModeRadio'),
            value: GameMode.team,
            groupValue: state.mode,
            onChanged: (value) {
              if (value != null) controller.updateMode(value);
            },
            title: const Text('Team'),
          ),
          if (state.mode == GameMode.team) ...[
            const SizedBox(height: 16),
            Text(
              'Teams',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...List.generate(state.teams.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Team ${index + 1}',
                  ),
                  controller:
                      TextEditingController(text: state.teams[index].name)
                        ..selection = TextSelection.collapsed(
                          offset: state.teams[index].name.length,
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
                label: const Text('Add Team'),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Rules',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CheckboxListTile(
            value: state.bestOneEnabled,
            onChanged: (value) => controller.setBestOneEnabled(value ?? false),
            title: const Text('Best One'),
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: state.bestTwoEnabled,
            onChanged: (value) => controller.setBestTwoEnabled(value ?? false),
            title: const Text('Best Two'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: state.sharedBetDefault,
            onChanged: controller.setSharedBetDefault,
            title: const Text('Use same amount for all rules'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Best One Amount',
            ),
            controller: TextEditingController(
              text: state.bestOneAmount?.toString() ?? '',
            )..selection = TextSelection.collapsed(
                offset: (state.bestOneAmount?.toString() ?? '').length,
              ),
            onChanged: controller.updateBestOneAmount,
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: state.sharedBetDefault
                  ? 'Best Two Amount (optional)'
                  : 'Best Two Amount',
            ),
            controller: TextEditingController(
              text: state.bestTwoAmount?.toString() ?? '',
            )..selection = TextSelection.collapsed(
                offset: (state.bestTwoAmount?.toString() ?? '').length,
              ),
            onChanged: controller.updateBestTwoAmount,
          ),
          const SizedBox(height: 24),
          Text(
            'Hole Setup',
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
                child: const Text('Set Turbo 9 & 18'),
              ),
              OutlinedButton(
                onPressed: controller.applyBirdieBonusFor9And18,
                child: const Text('Set Birdie 9 & 18'),
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
                        'Hole ${hole.holeNumber}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Par',
                      ),
                      controller: TextEditingController(
                        text: hole.par.toString(),
                      )..selection = TextSelection.collapsed(
                          offset: hole.par.toString().length,
                        ),
                      onChanged: (value) =>
                          controller.updateHolePar(index, value),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: hole.isTurbo,
                      onChanged: (value) =>
                          controller.updateHoleTurbo(index, value),
                      title: const Text('Turbo x2'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      value: hole.isBirdieBonus,
                      onChanged: (value) =>
                          controller.updateHoleBirdieBonus(index, value),
                      title: const Text('Birdie Bonus x2'),
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
                : const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
