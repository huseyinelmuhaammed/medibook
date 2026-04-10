import '../services/tc_validation_service.dart';

class Validators {
  static String? validateAd(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ad alanı zorunludur';
    }
    if (value.trim().length < 2) {
      return 'Ad en az 2 karakter olmalıdır';
    }
    return null;
  }

  static String? validateSoyad(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Soyad alanı zorunludur';
    }
    if (value.trim().length < 2) {
      return 'Soyad en az 2 karakter olmalıdır';
    }
    return null;
  }

  static String? validateTc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'TC Kimlik No zorunludur';
    }
    if (!TcValidationService.validateFormat(value.trim())) {
      return 'Geçersiz TC Kimlik No';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta alanı zorunludur';
    }
    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }

  static String? validateTelefon(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefon numarası zorunludur';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10 || digitsOnly.length > 11) {
      return 'Geçerli bir telefon numarası giriniz';
    }
    return null;
  }

  static String? validateDogumTarihi(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Doğum tarihi zorunludur';
    }
    return null;
  }

  static String? validateAdres(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Adres alanı zorunludur';
    }
    if (value.trim().length < 10) {
      return 'Adres en az 10 karakter olmalıdır';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName alanı zorunludur';
    }
    return null;
  }
}
