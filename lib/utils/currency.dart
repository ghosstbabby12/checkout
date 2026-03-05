import 'package:intl/intl.dart';

class CurrencyHelper {
  static String symbolForRegion(String region) {
    switch (region) {
      case 'US':
        return '4'; // placeholder overridden by NumberFormat below
      case 'MX':
        return 'MXN';
      case 'CO':
        return 'COP';
      case 'ES':
        return '€';
      default:
        return '4';
    }
  }

  static String format(double amount, String region) {
    // Map region to locale/currency
    String locale = 'en_US';
    String currency = 'USD';
    switch (region) {
      case 'US':
        locale = 'en_US';
        currency = 'USD';
        break;
      case 'MX':
        locale = 'es_MX';
        currency = 'MXN';
        break;
      case 'CO':
        locale = 'es_CO';
        currency = 'COP';
        break;
      case 'ES':
        locale = 'es_ES';
        currency = 'EUR';
        break;
    }
    final f = NumberFormat.currency(locale: locale, name: currency);
    return f.format(amount);
  }
}
