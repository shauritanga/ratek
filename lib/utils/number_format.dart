import 'package:intl/intl.dart';

String formatNumber(num number, {String type = 'default'}) {
  switch (type) {
    case 'currency':
      return NumberFormat.currency(locale: 'en_US', symbol: '\$')
          .format(number);
    case 'short':
      if (number >= 1e6) {
        return '${(number / 1e6).toStringAsFixed(1)}M'; // Millions
      } else if (number >= 1e3) {
        return '${(number / 1e3).toStringAsFixed(1)}K'; // Thousands
      } else {
        return number.toString(); // Plain number
      }
    case 'percentage':
      return NumberFormat.percentPattern().format(number);
    default:
      return number.toString(); // Default plain number
  }
}
