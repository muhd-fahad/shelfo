import 'package:intl/intl.dart';
import 'package:shelfo/models/currency/currency.dart';

class CurrencyFormatter {
  static String format(double amount, Currency currency, {bool showSymbol = true}) {
    final format = NumberFormat.currency(
      symbol: showSymbol ? currency.symbol : '',
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  static String formatCompact(double amount, Currency currency) {
    final format = NumberFormat.compactCurrency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return format.format(amount);
  }
}
