import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HoleResultScreen extends ConsumerWidget {
  final String gameId;
  final int holeNumber;

  const HoleResultScreen({
    super.key,
    required this.gameId,
    required this.holeNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(
      holeResultProvider((gameId: gameId, holeNumber: holeNumber)),
    );
    final settingsAsync = ref.watch(appSettingsProvider);

    return AppScaffold(
      title: 'Hole Result',
      body: settingsAsync.when(
        data: (settings) {
          return resultAsync.when(
            data: (result) {
              if (result == null) {
                return const Center(
                  child: Text('No result available yet.'),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Hole ${result.holeNumber}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.isComplete ? 'Complete' : 'Incomplete',
                  ),
                  const SizedBox(height: 8),
                  Text('Turbo: ${result.isTurbo ? 'ON' : 'OFF'}'),
                  Text('Birdie Bonus: ${result.isBirdieBonus ? 'ON' : 'OFF'}'),
                  if (result.baseAmount != null)
                    Text(
                      'Base Amount: ${CurrencyFormatter.format(result.baseAmount!, settings.currency)}',
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Player Net',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.playerNet.isEmpty)
                    const Text('No player net result.')
                  else
                    ...result.playerNet.entries.map(
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
                    'Team Net',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.teamNet.isEmpty)
                    const Text('No team net result.')
                  else
                    ...result.teamNet.entries.map(
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
                    'Player Movements',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.playerMovements.isEmpty)
                    const Text('No player movements.')
                  else
                    ...result.playerMovements.map(
                      (move) => Card(
                        child: ListTile(
                          title: Text('${move.fromId} → ${move.toId}'),
                          subtitle: Text('${move.rule} • ${move.note}'),
                          trailing: Text(
                            CurrencyFormatter.format(
                              move.amount,
                              settings.currency,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Team Movements',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.teamMovements.isEmpty)
                    const Text('No team movements.')
                  else
                    ...result.teamMovements.map(
                      (move) => Card(
                        child: ListTile(
                          title: Text('${move.fromTeamId} → ${move.toTeamId}'),
                          subtitle: Text('${move.rule} • ${move.note}'),
                          trailing: Text(
                            CurrencyFormatter.format(
                              move.amount,
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
              child: Text('Failed to load hole result: $error'),
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
