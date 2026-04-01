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
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Currency'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Thai'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('THB'), findsOneWidget);
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

    await tester.tap(find.text('Thai'));
    await tester.pump();

    expect(find.text('ภาษา'), findsOneWidget);
    expect(find.text('สกุลเงิน'), findsOneWidget);
  });
}
