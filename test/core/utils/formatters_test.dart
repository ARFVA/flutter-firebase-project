import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyquest/core/utils/formatters.dart';

void main() {
  group('number formatters', () {
    test('formats compact and grouped numbers', () {
      expect(formatNumber(1500), '1.5K');
      expect(formatNumberWithSeparator(1500000), '1.500.000');
    });

    test('formats digits in text input with a thousands separator', () {
      final formatter = ThousandsSeparatorInputFormatter();

      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(
          text: '123456',
          selection: TextSelection.collapsed(offset: 6),
        ),
      );

      expect(result.text, '123.456');
      expect(result.selection, const TextSelection.collapsed(offset: 7));
    });
  });
}
