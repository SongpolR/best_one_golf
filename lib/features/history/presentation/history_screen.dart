import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
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
      title: 'History',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ongoing',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ongoingAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('No ongoing games'),
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
                title: Text('Failed to load ongoing games: $error'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Completed',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          completedAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('No completed games'),
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
                title: Text('Failed to load completed games: $error'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(game.title),
              subtitle: Text(
                '${game.mode.name} • ${game.totalHoles} holes',
              ),
              trailing: Text(
                isCompleted ? 'Completed' : 'Ongoing',
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
                    child: const Text('View'),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      context.push('/score-entry/${game.id}');
                    },
                    child: const Text('Continue'),
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
                    child: const Text('Restart'),
                  ),
                OutlinedButton(
                  onPressed: () async {
                    final confirmed = await _showDeleteDialog(context);
                    if (confirmed != true) return;

                    final deleteGame = ref.read(deleteGameUseCaseProvider);
                    await deleteGame(game.id);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: const Text('Do you want to delete this game permanently?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showRestartDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restart Game'),
          content: const Text(
            'Do you want to create a new game using the same settings?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }
}
