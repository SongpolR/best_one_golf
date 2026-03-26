import 'package:flutter_test/flutter_test.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formats USD correctly', () {
      expect(CurrencyFormatter.format(120, AppCurrency.usd), '\$120');
    });

    test('formats THB correctly', () {
      expect(CurrencyFormatter.format(120, AppCurrency.thb), '฿120');
    });

    test('formats signed positive correctly', () {
      expect(CurrencyFormatter.formatSigned(120, AppCurrency.usd), '+\$120');
    });

    test('formats signed negative correctly', () {
      expect(CurrencyFormatter.formatSigned(-120, AppCurrency.usd), '-\$120');
    });

    test('formats zero without sign', () {
      expect(CurrencyFormatter.formatSigned(0, AppCurrency.usd), '\$0');
    });
  });
}
