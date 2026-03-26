import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BestOneGolf',
      actions: [
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Game coming soon')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Game'),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Games',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.sports_golf),
              title: Text('No games yet'),
              subtitle: Text('Start your first BestOneGolf game'),
            ),
          ),
        ],
      ),
    );
  }
}
