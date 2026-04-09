import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/core/enums/app_theme_mode.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/domain/entities/game_list_item.dart';
import 'package:best_one_golf/features/home/presentation/home_screen.dart';
import 'package:best_one_golf/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_game_repository.dart';

Widget buildHomeTestApp({
  List<GameListItem> ongoingGames = const [],
  List<GameListItem> completedGames = const [],
}) {
  return ProviderScope(
    overrides: [
      appSettingsProvider.overrideWith(
        (ref) => Stream.value(
          const AppSettings(
              language: AppLanguage.en,
              currency: AppCurrency.usd,
              themeMode: AppThemeMode.system),
        ),
      ),
      ongoingGamesProvider.overrideWith((ref) => Stream.value(ongoingGames)),
      completedGamesProvider
          .overrideWith((ref) => Stream.value(completedGames)),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );
}

void main() {
  testWidgets('Home screen renders primary content', (tester) async {
    await tester.pumpWidget(buildHomeTestApp());
    await tester.pumpAndSettle();

    expect(find.text('New Game'), findsOneWidget);
    expect(find.text('Recent Games'), findsOneWidget);
    expect(find.text('No games yet'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
  });

  testWidgets('Home screen shows recent games when available', (tester) async {
    await tester.pumpWidget(buildHomeTestApp(
      ongoingGames: [fakeGameListItem(id: 'game-1', title: 'Saturday Match')],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('No games yet'), findsNothing);
  });

  testWidgets('Home screen caps recent games at 5', (tester) async {
    await tester.pumpWidget(buildHomeTestApp(
      ongoingGames: List.generate(
        6,
        (i) => fakeGameListItem(id: 'game-$i', title: 'Match $i'),
      ),
    ));
    await tester.pumpAndSettle();

    // 6 games provided but only 5 should be shown
    expect(find.textContaining('Match'), findsNWidgets(5));
  });
}
