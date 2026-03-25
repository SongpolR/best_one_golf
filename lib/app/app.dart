import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/app_theme.dart';

enum AppLanguage { en, th }

enum AppCurrency { usd, thb }

class AppSettingsState {
  final AppLanguage language;
  final AppCurrency currency;

  const AppSettingsState({
    required this.language,
    required this.currency,
  });

  AppSettingsState copyWith({
    AppLanguage? language,
    AppCurrency? currency,
  }) {
    return AppSettingsState(
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  @override
  AppSettingsState build() {
    return const AppSettingsState(
      language: AppLanguage.en,
      currency: AppCurrency.usd,
    );
  }

  void updateLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }

  void updateCurrency(AppCurrency currency) {
    state = state.copyWith(currency: currency);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);

class BestOneGolfApp extends ConsumerWidget {
  const BestOneGolfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BestOne',
      theme: AppTheme.light(),
      routerConfig: router,
      locale: Locale(settings.language == AppLanguage.en ? 'en' : 'th'),
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
