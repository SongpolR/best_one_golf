import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.appName,
      actions: [
        IconButton(
          onPressed: () => context.push('/history'),
          icon: const Icon(Icons.history),
          tooltip: 'History',
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
            onPressed: () => context.push('/create-game'),
            icon: const Icon(Icons.add),
            label: Text(l10n.newGame),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.recentGames,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sports_golf),
              title: Text(l10n.noGamesYet),
              subtitle: Text(l10n.startYourFirstGame),
            ),
          ),
        ],
      ),
    );
  }
}
