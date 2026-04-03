import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/enums/hole_state.dart';
import '../../../domain/entities/game_aggregate.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/number_stepper.dart';
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
  bool _initialHoleSet = false;

  /// +1 = swiping forward (next hole), -1 = swiping backward (previous hole).
  int _slideDirection = 1;

  void _onInitialData(GameAggregate aggregate) {
    if (_initialHoleSet) return;
    _initialHoleSet = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(scoreEntryControllerProvider)
            .jumpToFirstIncompleteHole(aggregate);
      }
    });
  }

  Future<void> _finishGame(String gameId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.finishGame),
          content: Text(l10n.finishGameConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.finish),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final finalizeGame = ref.read(finalizeGameUseCaseProvider);
    await finalizeGame(gameId);

    if (!mounted) return;

    context.push('/game-summary/$gameId');
  }

  @override
  Widget build(BuildContext context) {
    final gameId = widget.gameId;

    final aggregateAsync = ref.watch(gameAggregateProvider(gameId));
    final selectedHole = ref.watch(selectedHoleProvider);
    final controller = ref.read(scoreEntryControllerProvider);

    final l10n = AppLocalizations.of(context)!;

    ref.listen<int>(selectedHoleProvider, (prev, next) {
      if (prev != null && next != prev) {
        setState(() {
          _slideDirection = next > prev ? 1 : -1;
        });
      }
    });

    return aggregateAsync.when(
      data: (aggregate) {
        _onInitialData(aggregate);

        final currentHoleScores = <String, int?>{
          for (final score in aggregate.holeScores
              .where((score) => score.holeNumber == selectedHole))
            score.playerId: score.strokes,
        };

        final holeConfig = aggregate.holeConfigs.firstWhere(
          (h) => h.holeNumber == selectedHole,
        );

        final teamNameById = {
          for (final team in aggregate.teams) team.id: team.name,
        };

        return AppScaffold(
          title: l10n.scoreEntry,
          leading: BackButton(onPressed: () => context.go('/')),
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              const velocityThreshold = 300.0;
              final vx = details.primaryVelocity ?? 0;
              if (vx < -velocityThreshold) {
                controller.nextHole(aggregate);
              } else if (vx > velocityThreshold) {
                controller.previousHole();
              }
            },
            child: Column(
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
                        '${l10n.holeProgress(selectedHole, aggregate.game.totalHoles)}  •  ${l10n.par} ${holeConfig.par}',
                        key: const Key('scoreEntryHoleLabel'),
                        style: Theme.of(context).textTheme.titleMedium,
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

                          final cs = Theme.of(context).colorScheme;
                          final Color bg;
                          final Color fg;
                          switch (holeState) {
                            case HoleState.empty:
                              bg = cs.outlineVariant;
                              fg = cs.onSurfaceVariant;
                            case HoleState.partial:
                              bg = AppColors.yellow;
                              fg = AppColors.wolf;
                            case HoleState.complete:
                              bg = AppColors.green;
                              fg = Colors.white;
                          }

                          final isSelected = holeNumber == selectedHole;

                          return InkWell(
                            onTap: () => controller.jumpToHole(holeNumber),
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(18),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.blue,
                                        width: 2.5,
                                      )
                                    : null,
                              ),
                              child: Text(
                                '$holeNumber',
                                style: TextStyle(
                                  color: fg,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ClipRect(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      layoutBuilder: (currentChild, previousChildren) => Stack(
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      ),
                      transitionBuilder: (child, animation) {
                        final isIncoming = child.key == ValueKey(selectedHole);
                        final beginOffset = isIncoming
                            ? Offset(_slideDirection.toDouble(), 0)
                            : Offset.zero;
                        final endOffset = isIncoming
                            ? Offset.zero
                            : Offset(-_slideDirection.toDouble(), 0);
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: beginOffset,
                            end: endOffset,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: ListView.separated(
                        key: ValueKey(selectedHole),
                        padding: const EdgeInsets.all(16),
                        itemCount: aggregate.players.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final player = aggregate.players[index];
                          final value = currentHoleScores[player.id];

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (player.teamId != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '${l10n.team}: ${teamNameById[player.teamId] ?? player.teamId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  NumberStepper(
                                    key: Key(
                                        'scoreField_${selectedHole}_${player.id}'),
                                    value: value,
                                    min: 1,
                                    max: 12,
                                    label: l10n.score,
                                    nullable: true,
                                    incrementKey: Key(
                                        'scoreField_${selectedHole}_${player.id}_increment'),
                                    decrementKey: Key(
                                        'scoreField_${selectedHole}_${player.id}_decrement'),
                                    onChanged: (v) {
                                      controller.updateScoreInt(
                                        gameId: gameId,
                                        holeNumber: selectedHole,
                                        playerId: player.id,
                                        strokes: v,
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
                                child: Text(l10n.holeResult),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                key: const Key('openGameSummaryButton'),
                                onPressed: () {
                                  context.push('/game-summary/$gameId');
                                },
                                child: Text(l10n.gameSummary),
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
                                child: Text(l10n.prev),
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
                                child: Text(l10n.next),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            key: const Key('finishGameButton'),
                            onPressed: aggregate.game.status == 'completed'
                                ? null
                                : () => _finishGame(gameId),
                            child: Text(l10n.finishGame),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => AppScaffold(
        title: l10n.scoreEntry,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: l10n.scoreEntry,
        body: Center(
          child: Text(l10n.failedToLoadGame(error)),
        ),
      ),
    );
  }
}
