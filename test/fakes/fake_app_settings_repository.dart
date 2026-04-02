import 'dart:async';

import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/core/enums/app_theme_mode.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/domain/repositories/app_settings_repository.dart';

class FakeAppSettingsRepository implements AppSettingsRepository {
  FakeAppSettingsRepository({
    AppSettings? initialSettings,
  }) : _settings = initialSettings ??
            const AppSettings(
              language: AppLanguage.en,
              currency: AppCurrency.usd,
              themeMode: AppThemeMode.system,
            );

  AppSettings _settings;
  final StreamController<AppSettings> _controller =
      StreamController<AppSettings>.broadcast();

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Stream<AppSettings> watchSettings() async* {
    yield _settings;
    yield* _controller.stream;
  }

  @override
  Future<void> updateCurrency(AppCurrency currency) async {
    _settings = _settings.copyWith(currency: currency);
    _controller.add(_settings);
  }

  @override
  Future<void> updateLanguage(AppLanguage language) async {
    _settings = _settings.copyWith(language: language);
    _controller.add(_settings);
  }

  @override
  Future<void> updateThemeMode(AppThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    _controller.add(_settings);
  }

  @override
  Future<void> updateAdsRemoved(bool removed) async {
    _settings = _settings.copyWith(adsRemoved: removed);
    _controller.add(_settings);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
