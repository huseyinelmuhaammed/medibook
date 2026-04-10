import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// 0(5XX) XXX XX XX formatında Türk cep telefon numarası formatlayıcı
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;
    final formatted = _buildFormatted(limited);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _buildFormatted(String digits) {
    if (digits.isEmpty) return '';
    final buf = StringBuffer();

    // d[0] → '0'
    buf.write(digits[0]);

    if (digits.length > 1) {
      buf.write('(');
      // d[1..3] → '5XX'
      buf.write(digits.substring(1, digits.length.clamp(0, 4)));
    }

    if (digits.length > 4) {
      buf.write(') ');
      // d[4..6] → 'XXX'
      buf.write(digits.substring(4, digits.length.clamp(0, 7)));
    }

    if (digits.length > 7) {
      buf.write(' ');
      // d[7..8] → 'XX'
      buf.write(digits.substring(7, digits.length.clamp(0, 9)));
    }

    if (digits.length > 9) {
      buf.write(' ');
      // d[9..10] → 'XX'
      buf.write(digits.substring(9, digits.length.clamp(0, 11)));
    }

    return buf.toString();
  }
}

/// Sadece rakam girişine izin veren formatlayıcı
class DigitsOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

class AppFormatters {
  AppFormatters._();

  static final DateFormat dateDisplay = DateFormat('dd MMMM yyyy', 'tr_TR');
  static final DateFormat dateSave = DateFormat('yyyy-MM-dd');
  static final DateFormat dateShort = DateFormat('dd/MM/yyyy');

  static String formatDate(DateTime date) => dateDisplay.format(date);

  static String formatDateShort(DateTime date) => dateShort.format(date);

  static String formatCurrency(double amount) {
    final f = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 2);
    return f.format(amount);
  }

  /// Telefon numarasından saf rakamları döner
  static String phoneDigitsOnly(String formatted) {
    return formatted.replaceAll(RegExp(r'\D'), '');
  }
}
