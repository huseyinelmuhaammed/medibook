import '../utils/validators.dart';

enum TcCheckState { idle, checking, valid, invalid }

/// TC kimlik numarasının benzersizliğini mock async servis ile kontrol eder.
/// Gerçek API yerine Future.delayed ile simüle edilmiştir.
class TcValidationService {
  TcValidationService._();

  /// Bloklanmış (kayıtlı olmayan) mock TC numaraları
  static const Set<String> _blockedTcNumbers = {
    '10000000000',
    '99999999994',
  };

  /// TC numarasını doğrular; formatı geçerliyse async sorgulama yapar.
  static Future<TcCheckResult> validate(String tc) async {
    // Önce senkron format/algoritma kontrolü
    final syncError = Validators.validateTc(tc);
    if (syncError != null) {
      return TcCheckResult(isValid: false, message: syncError);
    }

    // Mock network gecikmesi
    await Future.delayed(const Duration(milliseconds: 1200));

    if (_blockedTcNumbers.contains(tc)) {
      return TcCheckResult(
        isValid: false,
        message: 'Bu TC numarası sistemde kayıtlı değil',
      );
    }

    return TcCheckResult(isValid: true, message: 'TC numarası doğrulandı');
  }
}

class TcCheckResult {
  final bool isValid;
  final String message;

  const TcCheckResult({required this.isValid, required this.message});
}
