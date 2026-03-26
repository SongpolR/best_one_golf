import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/app_currency.dart';
import '../../../core/enums/app_language.dart';
import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final repository = ref.watch(appSettingsRepositoryProvider);

    return AppScaffold(
      title: 'Settings',
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
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
                          repository.updateLanguage(value);
                        }
                      },
                      title: const Text('English'),
                    ),
                    RadioListTile<AppLanguage>(
                      value: AppLanguage.th,
                      groupValue: settings.language,
                      onChanged: (value) {
                        if (value != null) {
                          repository.updateLanguage(value);
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
                          repository.updateCurrency(value);
                        }
                      },
                      title: const Text('USD'),
                    ),
                    RadioListTile<AppCurrency>(
                      value: AppCurrency.thb,
                      groupValue: settings.currency,
                      onChanged: (value) {
                        if (value != null) {
                          repository.updateCurrency(value);
                        }
                      },
                      title: const Text('THB'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to load settings: $error'),
        ),
      ),
    );
  }
}
