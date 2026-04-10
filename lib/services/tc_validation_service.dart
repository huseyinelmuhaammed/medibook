class TcValidationService {
  static bool validateFormat(String tc) {
    if (tc.length != 11) return false;
    if (tc[0] == '0') return false;

    final digits = tc.split('').map((c) => int.tryParse(c)).toList();
    if (digits.any((d) => d == null)) return false;

    final d = digits.cast<int>();

    final oddSum = d[0] + d[2] + d[4] + d[6] + d[8];
    final evenSum = d[1] + d[3] + d[5] + d[7];

    if ((oddSum * 7 - evenSum) % 10 != d[9]) return false;

    final firstTenSum = d.take(10).reduce((a, b) => a + b);
    if (firstTenSum % 10 != d[10]) return false;

    return true;
  }

  static Future<bool> validateAsync(String tc) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return validateFormat(tc);
  }
}
