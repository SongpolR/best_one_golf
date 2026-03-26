import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/app_settings_repository_impl.dart';
import '../domain/entities/app_settings.dart';
import '../domain/repositories/app_settings_repository.dart';
import 'router.dart';
import 'theme/app_theme.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppSettingsRepositoryImpl(db);
});

final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watchSettings();
});

class BestOneGolfApp extends ConsumerWidget {
  const BestOneGolfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final router = ref.watch(appRouterProvider);

    return settingsAsync.when(
      data: (settings) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'BestOneGolf',
          theme: AppTheme.light(),
          routerConfig: router,
          locale: Locale(settings.language.code),
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
      },
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: Text('App init error: $error'),
          ),
        ),
      ),
    );
  }
}
