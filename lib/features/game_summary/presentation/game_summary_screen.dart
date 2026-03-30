import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/game_mode.dart';
import '../../../core/enums/hole_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(gameSummaryProvider(gameId));
    final settingsAsync = ref.watch(appSettingsProvider);
    final aggregateAsync = ref.watch(gameAggregateProvider(gameId));

    return AppScaffold(
      title: l10n.gameSummary,
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
                    return Center(
                      child: Text(l10n.noSummaryAvailable),
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
                        l10n.gameInfo(
                          aggregate.game.mode == GameMode.individual
                              ? l10n.individual
                              : l10n.team,
                          aggregate.game.totalHoles,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Totals
                      Text(
                        l10n.totalsByPlayer,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (sortedTotals.isEmpty)
                        Text(l10n.noTotalsYet)
                      else
                        ...sortedTotals.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Card(
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
                        ),

                      const SizedBox(height: 24),

                      /// Settlements
                      Text(
                        l10n.settlements,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (settlements.isEmpty)
                        Text(l10n.noSettlementsYet)
                      else
                        ...settlements.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  l10n.pays(
                                    playerNameById[entry.fromId] ?? entry.fromId,
                                    playerNameById[entry.toId] ?? entry.toId,
                                  ),
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
                        ),

                      const SizedBox(height: 24),

                      /// Holes
                      Text(
                        l10n.holes,
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
                            key: Key('summaryHole_$holeNumber'),
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
                  child: Text(l10n.failedToLoadGameSummary(error)),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(l10n.failedToLoadGameData(error)),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(l10n.failedToLoadAppSettings(error)),
        ),
      ),
    );
  }
}