import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/core/enums/app_theme_mode.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/settings/presentation/settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_app_settings_repository.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('Settings screen renders language and currency sections',
      (tester) async {
    final fakeRepository = FakeAppSettingsRepository(
      initialSettings: const AppSettings(
        language: AppLanguage.en,
        currency: AppCurrency.usd,
        themeMode: AppThemeMode.system,
      ),
    );

    await tester.pumpWidget(
      pumpTestApp(
        child: const SettingsScreen(),
        repository: fakeRepository,
      ),
    );

    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Remove Ads'), findsOneWidget);

    // Scroll down to reveal Language and Currency sections.
    await tester.scrollUntilVisible(find.text('Language'), 100);
    await tester.pump();
    expect(find.text('Language'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Currency'), 100);
    await tester.pump();
    expect(find.text('Currency'), findsOneWidget);
  });

  testWidgets('Settings screen updates language selection', (tester) async {
    final fakeRepository = FakeAppSettingsRepository(
      initialSettings: const AppSettings(
        language: AppLanguage.en,
        currency: AppCurrency.usd,
        themeMode: AppThemeMode.system,
      ),
    );

    await tester.pumpWidget(
      pumpTestApp(
        child: const SettingsScreen(),
        repository: fakeRepository,
      ),
    );

    await tester.pump();

    await tester.scrollUntilVisible(find.text('Thai'), 100);
    await tester.ensureVisible(find.text('Thai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thai'));
    await tester.pump();

    expect(find.text('ภาษา'), findsOneWidget);
    expect(find.text('สกุลเงิน'), findsOneWidget);
  });
}
