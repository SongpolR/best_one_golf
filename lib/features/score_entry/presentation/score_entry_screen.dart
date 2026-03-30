import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/hole_state.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../hole_result/presentation/hole_result_sheet.dart';
import 'score_entry_controller.dart';

class ScoreEntryScreen extends ConsumerStatefulWidget {
  final String gameId;

  const ScoreEntryScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<ScoreEntryScreen> createState() => _ScoreEntryScreenState();
}

class _ScoreEntryScreenState extends ConsumerState<ScoreEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(Map<String, int?> scores) {
    for (final entry in scores.entries) {
      final playerId = entry.key;
      final value = entry.value;
      final text = value?.toString() ?? '';

      final existing = _controllers[playerId];
      if (existing == null) {
        _controllers[playerId] = TextEditingController(text: text);
      } else if (existing.text != text) {
        existing.value = existing.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
          composing: TextRange.empty,
        );
      }
    }

    final validIds = scores.keys.toSet();
    final toRemove =
        _controllers.keys.where((id) => !validIds.contains(id)).toList();

    for (final id in toRemove) {
      _controllers[id]?.dispose();
      _controllers.remove(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameId = widget.gameId;

    final aggregateAsync = ref.watch(gameAggregateProvider(gameId));
    final selectedHole = ref.watch(selectedHoleProvider);
    final controller = ref.read(scoreEntryControllerProvider);

    return aggregateAsync.when(
      data: (aggregate) {
        final currentHoleScores = <String, int?>{
          for (final score in aggregate.holeScores
              .where((score) => score.holeNumber == selectedHole))
            score.playerId: score.strokes,
        };

        _syncControllers(currentHoleScores);

        return AppScaffold(
          title: 'Score Entry',
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      aggregate.game.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hole $selectedHole / ${aggregate.game.totalHoles}',
                      key: const Key('scoreEntryHoleLabel'),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(aggregate.game.totalHoles, (index) {
                        final holeNumber = index + 1;
                        final holeState = controller.getHoleState(
                          aggregate: aggregate,
                          holeNumber: holeNumber,
                        );

                        Color? color;
                        switch (holeState) {
                          case HoleState.empty:
                            color = Colors.grey.shade300;
                            break;
                          case HoleState.partial:
                            color = Colors.orange.shade300;
                            break;
                          case HoleState.complete:
                            color = Colors.green.shade300;
                            break;
                        }

                        final isSelected = holeNumber == selectedHole;

                        return InkWell(
                          onTap: () => controller.jumpToHole(holeNumber),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(18),
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Text('$holeNumber'),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: aggregate.players.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final player = aggregate.players[index];
                    final value = currentHoleScores[player.id];
                    final textController = _controllers[player.id] ??
                        TextEditingController(text: value?.toString() ?? '');

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (player.teamId != null) ...[
                              const SizedBox(height: 4),
                              const Text('Team assigned'),
                            ],
                            const SizedBox(height: 12),
                            TextField(
                              key: Key(
                                  'scoreField_${selectedHole}_${player.id}'),
                              controller: textController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Score',
                              ),
                              onChanged: (text) {
                                controller.updateScore(
                                  gameId: gameId,
                                  holeNumber: selectedHole,
                                  playerId: player.id,
                                  value: text,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('openHoleResultButton'),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (_) {
                                    return HoleResultSheet(
                                      gameId: gameId,
                                      holeNumber: selectedHole,
                                    );
                                  },
                                );
                              },
                              child: const Text('Hole Result'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('openGameSummaryButton'),
                              onPressed: () {
                                context.push('/game-summary/$gameId');
                              },
                              child: const Text('Game Summary'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('prevHoleButton'),
                              onPressed: selectedHole > 1
                                  ? controller.previousHole
                                  : null,
                              child: const Text('Prev'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              key: const Key('nextHoleButton'),
                              onPressed:
                                  selectedHole < aggregate.game.totalHoles
                                      ? () => controller.nextHole(aggregate)
                                      : null,
                              child: const Text('Next'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const AppScaffold(
        title: 'Score Entry',
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: 'Score Entry',
        body: Center(
          child: Text('Failed to load game: $error'),
        ),
      ),
    );
  }
}
