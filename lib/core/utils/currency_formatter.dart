import '../enums/app_currency.dart';

class CurrencyFormatter {
  static String format(int amount, AppCurrency currency) {
    switch (currency) {
      case AppCurrency.usd:
        return '\$${amount.abs()}';
      case AppCurrency.thb:
        return '฿${amount.abs()}';
    }
  }

  static String formatSigned(int amount, AppCurrency currency) {
    final sign = amount > 0
        ? '+'
        : amount < 0
            ? '-'
            : '';
    return '$sign${format(amount, currency)}';
  }
}
