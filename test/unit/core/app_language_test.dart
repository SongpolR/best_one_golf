import 'package:flutter_test/flutter_test.dart';
import 'package:best_one_golf/core/enums/app_language.dart';

void main() {
  group('AppLanguage', () {
    test('fromCode returns en for en', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.en);
    });

    test('fromCode returns th for th', () {
      expect(AppLanguage.fromCode('th'), AppLanguage.th);
    });

    test('fromCode falls back to en for invalid code', () {
      expect(AppLanguage.fromCode('xx'), AppLanguage.en);
    });
  });
}
