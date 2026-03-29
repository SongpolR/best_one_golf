import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/hole_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../hole_result/presentation/hole_result_sheet.dart';
import '../../score_entry/presentation/score_entry_controller.dart';
import '../../../shared/widgets/app_scaffold.dart';

class GameSummaryScreen extends ConsumerWidget {
  final String gameId;

  const GameSummaryScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(gameSummaryProvider(gameId));
    final settingsAsync = ref.watch(appSettingsProvider);
    final aggregateAsync = ref.watch(gameAggregateProvider(gameId));

    return AppScaffold(
      title: 'Game Summary',
      body: settingsAsync.when(
        data: (settings) {
          return aggregateAsync.when(
            data: (aggregate) {
              final playerNameById = {
                for (final player in aggregate.players) player.id: player.name,
              };

              return summaryAsync.when(
                data: (summary) {
                  if (summary == null) {
                    return const Center(
                      child: Text('No summary available yet.'),
                    );
                  }

                  final sortedTotals = summary.totalByPlayer.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));

                  final settlements = summary.settlements.toList()
                    ..sort((a, b) => b.amount.compareTo(a.amount));

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        aggregate.game.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${aggregate.game.mode.name} • ${aggregate.game.totalHoles} holes',
                      ),
                      const SizedBox(height: 24),

                      /// Totals
                      Text(
                        'Totals by Player',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (sortedTotals.isEmpty)
                        const Text('No totals yet.')
                      else
                        ...sortedTotals.map(
                          (entry) => Card(
                            child: ListTile(
                              title: Text(
                                playerNameById[entry.key] ?? entry.key,
                              ),
                              trailing: Text(
                                CurrencyFormatter.formatSigned(
                                  entry.value,
                                  settings.currency,
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      /// Settlements
                      Text(
                        'Settlements',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (settlements.isEmpty)
                        const Text('No settlements yet.')
                      else
                        ...settlements.map(
                          (entry) => Card(
                            child: ListTile(
                              title: Text(
                                '${playerNameById[entry.fromId] ?? entry.fromId} pays ${playerNameById[entry.toId] ?? entry.toId}',
                              ),
                              trailing: Text(
                                CurrencyFormatter.format(
                                  entry.amount,
                                  settings.currency,
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      /// Holes
                      Text(
                        'Holes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            List.generate(aggregate.game.totalHoles, (index) {
                          final holeNumber = index + 1;
                          final state = ref
                              .read(scoreEntryControllerProvider)
                              .getHoleState(
                                aggregate: aggregate,
                                holeNumber: holeNumber,
                              );

                          Color? color;
                          switch (state) {
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

                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (_) {
                                  return HoleResultSheet(
                                    gameId: gameId,
                                    holeNumber: holeNumber,
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text('$holeNumber'),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Failed to load game summary: $error'),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text('Failed to load game data: $error'),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Failed to load app settings: $error'),
        ),
      ),
    );
  }
}
