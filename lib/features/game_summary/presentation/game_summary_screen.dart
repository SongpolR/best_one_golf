import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/utils/currency_formatter.dart';
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

    return AppScaffold(
      title: 'Game Summary',
      body: settingsAsync.when(
        data: (settings) {
          return summaryAsync.when(
            data: (summary) {
              if (summary == null) {
                return const Center(
                  child: Text('No summary available yet.'),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Totals by Player',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (summary.totalByPlayer.isEmpty)
                    const Text('No totals yet.')
                  else
                    ...summary.totalByPlayer.entries.map(
                      (entry) => Card(
                        child: ListTile(
                          title: Text(entry.key),
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
                  Text(
                    'Settlements',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (summary.settlements.isEmpty)
                    const Text('No settlements yet.')
                  else
                    ...summary.settlements.map(
                      (entry) => Card(
                        child: ListTile(
                          title: Text('${entry.fromId} pays ${entry.toId}'),
                          trailing: Text(
                            CurrencyFormatter.format(
                              entry.amount,
                              settings.currency,
                            ),
                          ),
                        ),
                      ),
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
          child: Text('Failed to load app settings: $error'),
        ),
      ),
    );
  }
}
