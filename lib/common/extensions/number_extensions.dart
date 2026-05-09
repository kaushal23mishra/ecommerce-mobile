import 'package:easy_localization/easy_localization.dart';

extension DoubleExtension on double {
  String get formatLakhsToRupees {
    int amount = (this * 100000).toInt(); // Convert lakhs to rupees
    return NumberFormat.decimalPattern(
      'en_IN',
    ).format(amount); // Format with commas
  }

  String get formatToIndianNumber {
    return NumberFormat.decimalPattern("en_IN").format(this);
  }
}

extension IntExtension on int {
  String get formatNumber {
    if (this < 9999) return toString();

    if (this >= 10000000) {
      return "${(this / 10000000).toStringAsFixed(1)}C";
    } else if (this >= 100000) {
      return "${(this / 100000).toStringAsFixed(1)}L";
    } else if (this >= 1000) {
      return "${(this / 1000).toStringAsFixed(1)}K";
    } else {
      return toString();
    }
  }

  String get formatIndianCommas {
    return NumberFormat.decimalPattern('en_IN').format(this);
  }
}

extension IndianNumberParsing on String {
  int parseIndianNumber() {
    try {
      return NumberFormat.decimalPattern('en_IN').parse(this).toInt();
    } catch (e) {
      return 0;
    }
  }
}
