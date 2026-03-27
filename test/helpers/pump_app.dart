import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/domain/repositories/app_settings_repository.dart';
import 'package:best_one_golf/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget pumpTestApp({
  required Widget child,
  AppSettingsRepository? repository,
  AppSettings? settings,
}) {
  return ProviderScope(
    overrides: [
      if (repository != null)
        appSettingsRepositoryProvider.overrideWithValue(repository),
      if (settings != null)
        appSettingsProvider.overrideWith((ref) => Stream.value(settings)),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final settingsAsync = ref.watch(appSettingsProvider);

        return settingsAsync.when(
          data: (appSettings) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Locale(appSettings.language.code),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: child,
            );
          },
          loading: () {
            return const MaterialApp(
              home: Scaffold(
                body: SizedBox.shrink(),
              ),
            );
          },
          error: (error, stackTrace) {
            return MaterialApp(
              home: Scaffold(
                body: Text('Test app error: $error'),
              ),
            );
          },
        );
      },
    ),
  );
}
