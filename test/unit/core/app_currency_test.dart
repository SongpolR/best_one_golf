import 'package:flutter_test/flutter_test.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';

void main() {
  group('AppCurrency', () {
    test('fromCode returns usd for USD', () {
      expect(AppCurrency.fromCode('USD'), AppCurrency.usd);
    });

    test('fromCode returns thb for THB', () {
      expect(AppCurrency.fromCode('THB'), AppCurrency.thb);
    });

    test('fromCode falls back to usd for invalid code', () {
      expect(AppCurrency.fromCode('XXX'), AppCurrency.usd);
    });
  });
}
