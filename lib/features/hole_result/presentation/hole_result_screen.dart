import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final resultAsync = ref.watch(
      holeResultProvider((gameId: gameId, holeNumber: holeNumber)),
    );
    final settingsAsync = ref.watch(appSettingsProvider);

    return AppScaffold(
      title: l10n.holeResult,
      body: settingsAsync.when(
        data: (settings) {
          return resultAsync.when(
            data: (result) {
              if (result == null) {
                return Center(
                  child: Text(l10n.noResultAvailable),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.holeN(result.holeNumber),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.isComplete ? l10n.complete : l10n.incomplete,
                  ),
                  const SizedBox(height: 8),
                  Text(result.isTurbo ? l10n.turboOn : l10n.turboOff),
                  Text(result.isBirdieBonus ? l10n.birdieOn : l10n.birdieOff),
                  if (result.baseAmount != null)
                    Text(
                      l10n.baseAmount(
                        CurrencyFormatter.format(
                          result.baseAmount!,
                          settings.currency,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.playerNet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.playerNet.isEmpty)
                    Text(l10n.noPlayerNetResult)
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
                    l10n.teamNet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.teamNet.isEmpty)
                    Text(l10n.noTeamNetResult)
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
                    l10n.playerMovements,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.playerMovements.isEmpty)
                    Text(l10n.noPlayerMovements)
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
                    l10n.teamMovements,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (result.teamMovements.isEmpty)
                    Text(l10n.noTeamMovements)
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
              child: Text(l10n.failedToLoadHoleResult(error)),
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