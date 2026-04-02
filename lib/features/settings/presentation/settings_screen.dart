import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/enums/app_currency.dart';
import '../../../core/enums/app_language.dart';
import '../../../core/enums/app_theme_mode.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final repository = ref.watch(appSettingsRepositoryProvider);
    final iapService = ref.watch(iapServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.settings,
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Remove Ads ─────────────────────────────────────────────────
              Text(
                l10n.removeAds,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: settings.adsRemoved
                      ? Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.removeAdsPurchased,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.removeAdsPurchasedDescription,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.removeAdsDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: iapService.storeAvailable
                                        ? () async {
                                            final ok = await iapService
                                                .purchaseRemoveAds();
                                            if (!ok && context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.storeNotAvailable,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                    child: Text(l10n.purchase),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: iapService.storeAvailable
                                      ? () => iapService.restorePurchases()
                                      : null,
                                  child: Text(l10n.restorePurchases),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Theme ──────────────────────────────────────────────────────
              Text(
                l10n.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.system,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        if (value != null) repository.updateThemeMode(value);
                      },
                      title: Text(l10n.systemTheme),
                      secondary: const Icon(Icons.brightness_auto_outlined),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.light,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        if (value != null) repository.updateThemeMode(value);
                      },
                      title: Text(l10n.lightTheme),
                      secondary: const Icon(Icons.light_mode_outlined),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.dark,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        if (value != null) repository.updateThemeMode(value);
                      },
                      title: Text(l10n.darkTheme),
                      secondary: const Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Language ───────────────────────────────────────────────────
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
                        if (value != null) repository.updateLanguage(value);
                      },
                      title: Text(l10n.english),
                    ),
                    RadioListTile<AppLanguage>(
                      value: AppLanguage.th,
                      groupValue: settings.language,
                      onChanged: (value) {
                        if (value != null) repository.updateLanguage(value);
                      },
                      title: Text(l10n.thai),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Currency ───────────────────────────────────────────────────
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
                        if (value != null) repository.updateCurrency(value);
                      },
                      title: Text(l10n.usd),
                    ),
                    RadioListTile<AppCurrency>(
                      value: AppCurrency.thb,
                      groupValue: settings.currency,
                      onChanged: (value) {
                        if (value != null) repository.updateCurrency(value);
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
