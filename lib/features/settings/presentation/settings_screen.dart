import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/enums/app_currency.dart';
import '../../../core/enums/app_language.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final repository = ref.watch(appSettingsRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.settings,
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.language,
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
                      title: Text(l10n.english),
                    ),
                    RadioListTile<AppLanguage>(
                      value: AppLanguage.th,
                      groupValue: settings.language,
                      onChanged: (value) {
                        if (value != null) {
                          repository.updateLanguage(value);
                        }
                      },
                      title: Text(l10n.thai),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.currency,
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
                      title: Text(l10n.usd),
                    ),
                    RadioListTile<AppCurrency>(
                      value: AppCurrency.thb,
                      groupValue: settings.currency,
                      onChanged: (value) {
                        if (value != null) {
                          repository.updateCurrency(value);
                        }
                      },
                      title: Text(l10n.thb),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(l10n.failedToLoadSettings(error)),
        ),
      ),
    );
  }
}
