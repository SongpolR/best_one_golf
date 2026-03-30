import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../core/enums/game_mode.dart';
import '../../../domain/entities/game_list_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ongoingAsync = ref.watch(ongoingGamesProvider);
    final completedAsync = ref.watch(completedGamesProvider);

    return AppScaffold(
      title: l10n.history,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.ongoing,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ongoingAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Card(
                  child: ListTile(
                    title: Text(l10n.noOngoingGames),
                  ),
                );
              }

              return Column(
                children: items
                    .map(
                      (game) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GameCard(
                          game: game,
                          isCompleted: false,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Card(
              child: ListTile(
                title: Text(l10n.failedToLoadOngoingGames(error)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.completed,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          completedAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Card(
                  child: ListTile(
                    title: Text(l10n.noCompletedGames),
                  ),
                );
              }

              return Column(
                children: items
                    .map(
                      (game) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GameCard(
                          game: game,
                          isCompleted: true,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Card(
              child: ListTile(
                title: Text(l10n.failedToLoadCompletedGames(error)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends ConsumerWidget {
  final GameListItem game;
  final bool isCompleted;

  const _GameCard({
    required this.game,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(game.title),
              subtitle: Text(
                l10n.gameInfo(
                  game.mode == GameMode.individual
                      ? l10n.individual
                      : l10n.team,
                  game.totalHoles,
                ),
              ),
              trailing: Text(
                isCompleted ? l10n.completed : l10n.ongoing,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isCompleted)
                  OutlinedButton(
                    onPressed: () {
                      context.push('/score-entry/${game.id}');
                    },
                    child: Text(l10n.view),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      context.push('/score-entry/${game.id}');
                    },
                    child: Text(l10n.continueGame),
                  ),
                if (!isCompleted)
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await _showRestartDialog(context);
                      if (confirmed != true) return;

                      final restartGame = ref.read(restartGameUseCaseProvider);
                      final newGameId = await restartGame(game.id);

                      if (context.mounted) {
                        context.go('/score-entry/$newGameId');
                      }
                    },
                    child: Text(l10n.restart),
                  ),
                OutlinedButton(
                  onPressed: () async {
                    final confirmed = await _showDeleteDialog(context);
                    if (confirmed != true) return;

                    final deleteGame = ref.read(deleteGameUseCaseProvider);
                    await deleteGame(game.id);
                  },
                  child: Text(l10n.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteGame),
          content: Text(l10n.deleteGameConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showRestartDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.restartGame),
          content: Text(l10n.restartGameConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.restart),
            ),
          ],
        );
      },
    );
  }
}