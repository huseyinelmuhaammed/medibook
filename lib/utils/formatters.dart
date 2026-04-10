import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String formatTarih(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'tr').format(date);
  }

  static String formatSaat(String saat) {
    return saat;
  }

  static String formatPara(double amount) {
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return formatter.format(amount);
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 11) {
      return oldValue;
    }
    return newValue.copyWith(text: digitsOnly);
  }
}

class TcInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 11) {
      return oldValue;
    }
    return newValue.copyWith(text: digitsOnly);
  }
}
