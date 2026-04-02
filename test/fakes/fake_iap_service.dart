import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/core/enums/app_theme_mode.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/services/iap_service.dart';

import 'fake_app_settings_repository.dart';

class FakeIapService extends IapService {
  FakeIapService()
      : super(
          FakeAppSettingsRepository(
            initialSettings: const AppSettings(
              language: AppLanguage.en,
              currency: AppCurrency.usd,
              themeMode: AppThemeMode.system,
            ),
          ),
        );

  @override
  Future<void> initialize() async {}
}
