import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final numberFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return numberFormat.format(amount);
}

int parseAmount(String value) {
  final digits = value.replaceAll('Rp ', '').replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}


class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Remove all non-digit characters
    int value = int.parse(newValue.text.replaceAll(RegExp(r'[^0-9]'), ''));

    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}