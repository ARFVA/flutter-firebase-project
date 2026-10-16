import 'package:flutter/services.dart';

/// Formats a number with compact suffix: 1500 -> "1.5K", 2500000 -> "2.5M".
String formatNumber(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return number.toString();
  }
}

/// Formats a number with dot thousands separators: 1500000 -> "1.500.000".
String formatNumberWithSeparator(int number) {
  final buffer = StringBuffer();
  final numberStr = number.toString();
  final length = numberStr.length;

  for (int i = 0; i < length; i++) {
    if (i > 0 && (length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(numberStr[i]);
  }

  return buffer.toString();
}

/// TextInputFormatter that keeps only digits and inserts dot separators.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}