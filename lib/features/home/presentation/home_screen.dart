import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../core/enums/game_mode.dart';
import '../../../domain/entities/game_list_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ad_countdown_dialog.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ongoingAsync = ref.watch(ongoingGamesProvider);
    final completedAsync = ref.watch(completedGamesProvider);

    final recentGames = ongoingAsync.whenData((ongoing) {
      return completedAsync.whenData((completed) {
        final all = [...ongoing, ...completed]
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return all.take(5).toList();
      }).valueOrNull;
    }).valueOrNull;

    return AppScaffold(
      title: l10n.appName,
      actions: [
        IconButton(
          onPressed: () => context.push('/history'),
          icon: const Icon(Icons.history),
          tooltip: l10n.history,
        ),
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings),
          tooltip: l10n.settings,
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () async {
              final settings = ref.read(appSettingsProvider).valueOrNull;
              if (settings?.adsRemoved == true) {
                context.push('/create-game');
                return;
              }

              final adService = ref.read(adServiceProvider);
              final shown = await adService.show();
              if (!shown && context.mounted) {
                await showAdCountdownDialog(context);
              }
              if (context.mounted) context.push('/create-game');
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.newGame),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.recentGames,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (ongoingAsync.isLoading || completedAsync.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (recentGames == null || recentGames.isEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.sports_golf),
                title: Text(l10n.noGamesYet),
                subtitle: Text(l10n.startYourFirstGame),
              ),
            )
          else
            ...recentGames.map(
              (game) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RecentGameCard(game: game),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentGameCard extends StatelessWidget {
  final GameListItem game;

  const _RecentGameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCompleted = game.status == 'completed';

    return Card(
      child: ListTile(
        title: Text(game.title),
        subtitle: Text(
          l10n.gameInfo(
            game.mode == GameMode.individual ? l10n.individual : l10n.team,
            game.totalHoles,
          ),
        ),
        trailing: OutlinedButton(
          onPressed: () => context.push('/score-entry/${game.id}'),
          child: Text(isCompleted ? l10n.view : l10n.continueGame),
        ),
      ),
    );
  }
}
