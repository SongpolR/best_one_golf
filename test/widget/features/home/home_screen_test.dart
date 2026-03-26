import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/home/presentation/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('Home screen renders primary content', (tester) async {
    await tester.pumpWidget(
      pumpTestApp(
        child: const HomeScreen(),
        settings: const AppSettings(
          language: AppLanguage.en,
          currency: AppCurrency.usd,
        ),
      ),
    );

    await tester.pump();

    expect(find.text('New Game'), findsOneWidget);
    expect(find.text('Recent Games'), findsOneWidget);
    expect(find.text('No games yet'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
  });
}
