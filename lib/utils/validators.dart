/// Tüm form validatörleri bu dosyada merkezi olarak tanımlanmıştır.
class Validators {
  Validators._();

  // ── TC Kimlik No ──────────────────────────────────────────────────────────────
  /// Türkiye TC Kimlik numarası doğrulaması.
  /// Geçerli örnek : 10000000146
  /// Geçersiz örnek: 12345678901
  static String? validateTc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'TC Kimlik No zorunludur';
    }
    final v = value.trim();
    if (v.length != 11) return 'TC Kimlik No 11 haneli olmalıdır';
    if (!RegExp(r'^\d{11}$').hasMatch(v)) {
      return 'TC Kimlik No sadece rakamdan oluşmalıdır';
    }
    if (v[0] == '0') return 'TC Kimlik No 0 ile başlayamaz';

    final d = v.split('').map(int.parse).toList();

    // 10. basamak kontrolü: (tek_toplam * 7 - cift_toplam) % 10 == d[9]
    final tekToplam = d[0] + d[2] + d[4] + d[6] + d[8];
    final ciftToplam = d[1] + d[3] + d[5] + d[7];
    if ((tekToplam * 7 - ciftToplam) % 10 != d[9]) {
      return 'Geçersiz TC Kimlik No';
    }

    // 11. basamak kontrolü: ilk 10 rakamın toplamı % 10 == d[10]
    final ilkOnToplam = d.take(10).reduce((a, b) => a + b);
    if (ilkOnToplam % 10 != d[10]) {
      return 'Geçersiz TC Kimlik No';
    }

    return null;
  }

  // ── İsim / Soyisim ────────────────────────────────────────────────────────────
  static String? validateAd(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ad zorunludur';
    final v = value.trim();
    if (v.length < 2) return 'Ad en az 2 karakter olmalıdır';
    if (!RegExp(r"^[a-zA-ZğüşıöçĞÜŞİÖÇ\s'-]+$").hasMatch(v)) {
      return 'Ad sadece harf içerebilir';
    }
    return null;
  }

  static String? validateSoyad(String? value) {
    if (value == null || value.trim().isEmpty) return 'Soyad zorunludur';
    final v = value.trim();
    if (v.length < 2) return 'Soyad en az 2 karakter olmalıdır';
    if (!RegExp(r"^[a-zA-ZğüşıöçĞÜŞİÖÇ\s'-]+$").hasMatch(v)) {
      return 'Soyad sadece harf içerebilir';
    }
    return null;
  }

  // ── E-posta ───────────────────────────────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'E-posta zorunludur';
    final v = value.trim();
    if (!RegExp(r'^[\w.+\-]+@[a-zA-Z\d\-]+\.[a-zA-Z\d\-.]+$').hasMatch(v)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  // ── Telefon ───────────────────────────────────────────────────────────────────
  /// Format: 0(5XX) XXX XX XX → sadece rakamlar alındığında 11 haneli
  static String? validateTelefon(String? value) {
    if (value == null || value.trim().isEmpty) return 'Telefon zorunludur';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return 'Geçerli bir telefon numarası girin';
    if (!digits.startsWith('05')) {
      return 'Telefon numarası 05 ile başlamalıdır';
    }
    return null;
  }

  // ── Doğum Tarihi ──────────────────────────────────────────────────────────────
  static String? validateDogumTarihi(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Doğum tarihi zorunludur';
    }
    return null; // DatePicker seçimle gelir, format hatası olmaz
  }

  // ── Adres ─────────────────────────────────────────────────────────────────────
  static String? validateAdres(String? value) {
    if (value == null || value.trim().isEmpty) return 'Adres zorunludur';
    if (value.trim().length < 10) return 'Adres en az 10 karakter olmalıdır';
    return null;
  }

  // ── Sigorta Firma ─────────────────────────────────────────────────────────────
  static String? validateSigortaFirma(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sigorta firması zorunludur';
    }
    return null;
  }

  // ── Alerji Açıklaması ─────────────────────────────────────────────────────────
  static String? validateAlerjiAciklama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alerji açıklaması zorunludur';
    }
    return null;
  }

  // ── Cinsiyet ──────────────────────────────────────────────────────────────────
  static String? validateCinsiyet(String? value) {
    if (value == null || value.isEmpty) return 'Cinsiyet seçimi zorunludur';
    return null;
  }

  // ── Zorunlu dropdown ─────────────────────────────────────────────────────────
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName seçimi zorunludur';
    return null;
  }

  // ── Notlar ────────────────────────────────────────────────────────────────────
  static String? validateNotlar(String? value) {
    if (value != null && value.length > 200) {
      return 'Notlar en fazla 200 karakter olabilir';
    }
    return null;
  }
}
