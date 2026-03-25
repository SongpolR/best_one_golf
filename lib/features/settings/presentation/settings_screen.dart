import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return AppScaffold(
      title: 'Settings',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Language',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<AppLanguage>(
                  value: AppLanguage.en,
                  groupValue: settings.language,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.updateLanguage(value);
                    }
                  },
                  title: const Text('English'),
                ),
                RadioListTile<AppLanguage>(
                  value: AppLanguage.th,
                  groupValue: settings.language,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.updateLanguage(value);
                    }
                  },
                  title: const Text('ไทย'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Currency',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<AppCurrency>(
                  value: AppCurrency.usd,
                  groupValue: settings.currency,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.updateCurrency(value);
                    }
                  },
                  title: const Text('USD'),
                ),
                RadioListTile<AppCurrency>(
                  value: AppCurrency.thb,
                  groupValue: settings.currency,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.updateCurrency(value);
                    }
                  },
                  title: const Text('THB'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
