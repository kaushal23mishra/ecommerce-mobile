import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class InputFormatters {
  static final panCard = [
    PANInputFormatter(),
    LengthLimitingTextInputFormatter(10),
  ];

  static final mobile = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  static final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

  static final name = [
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]*$')),
  ];

  static final lettersOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ];

  static final indianNumber = [IndianNumberInputFormatter()];
}

class PANInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String upperCaseValue = newValue.text.toUpperCase();
    String filteredValue = "";

    for (int i = 0; i < upperCaseValue.length; i++) {
      String char = upperCaseValue[i];

      if (i < 5) {
        if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
          filteredValue += char;
        }
      } else if (i >= 5 && i < 9) {
        if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
          filteredValue += char;
        }
      } else if (i == 9) {
        if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
          filteredValue += char;
        }
      }
    }

    if (filteredValue.length > 10) {
      filteredValue = filteredValue.substring(0, 10);
    }

    return newValue.copyWith(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}

class IndianNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If empty, return empty
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // Parse and format with Indian comma pattern
    try {
      int number = int.parse(digitsOnly);
      String formatted = NumberFormat.decimalPattern('en_IN').format(number);

      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } catch (e) {
      // If parsing fails, return old value
      return oldValue;
    }
  }
}
