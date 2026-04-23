import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:best_one_golf/data/local/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppSettingsDao', () {
    group('ensureSeeded', () {
      test('inserts default settings based on device locale', () async {
        await db.appSettingsDao.ensureSeeded();
        final settings = await db.appSettingsDao.getSettings();

        final deviceLocale =
            PlatformDispatcher.instance.locale.languageCode;

        if (deviceLocale == 'th') {
          expect(settings.languageCode, 'th');
          expect(settings.currencyCode, 'THB');
        } else {
          expect(settings.languageCode, 'en');
          expect(settings.currencyCode, 'USD');
        }
        expect(settings.themeModeCode, 'system');
        expect(settings.adsRemoved, false);
      });

      test('does not overwrite existing settings', () async {
        await db.appSettingsDao.ensureSeeded();
        await db.appSettingsDao.updateLanguage('th');
        await db.appSettingsDao.updateCurrency('THB');

        // Call again — should not reset
        await db.appSettingsDao.ensureSeeded();

        final settings = await db.appSettingsDao.getSettings();
        expect(settings.languageCode, 'th');
        expect(settings.currencyCode, 'THB');
      });
    });

    group('updateLanguage', () {
      test('updates language code', () async {
        await db.appSettingsDao.ensureSeeded();
        await db.appSettingsDao.updateLanguage('th');

        final settings = await db.appSettingsDao.getSettings();
        expect(settings.languageCode, 'th');
      });
    });

    group('updateCurrency', () {
      test('updates currency code', () async {
        await db.appSettingsDao.ensureSeeded();
        await db.appSettingsDao.updateCurrency('THB');

        final settings = await db.appSettingsDao.getSettings();
        expect(settings.currencyCode, 'THB');
      });
    });

    group('updateThemeMode', () {
      test('updates theme mode code', () async {
        await db.appSettingsDao.ensureSeeded();
        await db.appSettingsDao.updateThemeMode('dark');

        final settings = await db.appSettingsDao.getSettings();
        expect(settings.themeModeCode, 'dark');
      });
    });

    group('updateAdsRemoved', () {
      test('updates ads removed flag', () async {
        await db.appSettingsDao.ensureSeeded();
        await db.appSettingsDao.updateAdsRemoved(true);

        final settings = await db.appSettingsDao.getSettings();
        expect(settings.adsRemoved, true);
      });
    });

    group('watchSettings', () {
      test('emits settings when changed', () async {
        await db.appSettingsDao.ensureSeeded();

        final stream = db.appSettingsDao.watchSettings();

        // Get initial value
        final initial = await stream.first;
        expect(initial.themeModeCode, 'system');

        // Update and verify stream emits new value
        await db.appSettingsDao.updateThemeMode('light');
        final updated = await db.appSettingsDao.watchSettings().first;
        expect(updated.themeModeCode, 'light');
      });
    });
  });
}
