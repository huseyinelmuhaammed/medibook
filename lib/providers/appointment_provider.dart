import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data/mock_data.dart';
import '../models/doctor_model.dart';
import '../services/draft_service.dart';
import '../services/tc_validation_service.dart';

class AppointmentProvider extends ChangeNotifier {
  // ── Form Keys ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step3FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step4FormKey = GlobalKey<FormState>();

  // ── Wizard State ──────────────────────────────────────────────────────────────
  int _currentStep = 0;
  int get currentStep => _currentStep;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;

  String? _appointmentId;
  String? get appointmentId => _appointmentId;

  // ── Step 1 – Kişisel Bilgiler ─────────────────────────────────────────────────
  String ad = '';
  String soyad = '';
  String tc = '';
  String email = '';
  String telefon = '';
  String dogumTarihi = '';
  String cinsiyet = '';
  String adres = '';

  // TC async validation
  TcCheckState tcCheckState = TcCheckState.idle;
  String? tcCheckMessage;

  // ── Step 2 – Sigorta & Sağlık ─────────────────────────────────────────────────
  String sigortaTuru = '';
  String sigortaFirma = '';
  List<String> kronikHastaliklar = [];
  List<String> kullanilanIlaclar = [];
  bool alerjisi = false;
  String alerjiAciklama = '';

  // ── Step 3 – Bölüm & Doktor ──────────────────────────────────────────────────
  String sehir = '';
  String hastane = '';
  String bolum = '';
  String doktorId = '';
  DoctorModel? selectedDoctor;

  // Step 3 validation errors (dropdown kontrolü için)
  String? sehirError;
  String? hastaneError;
  String? bolumError;
  String? doktorError;

  // ── Step 4 – Tarih & Saat ────────────────────────────────────────────────────
  DateTime? selectedDate;
  String selectedSaat = '';
  bool acilRandevu = false;
  String notlar = '';

  // Step 4 validation errors
  String? tarihError;
  String? saatError;

  // ── Step 5 – Ek Hizmetler & Onaylar ──────────────────────────────────────────
  bool kanTahlili = false;
  bool mr = false;
  bool rontgen = false;
  int refakatciSayisi = 0;
  String ulasimYardimi = '';
  List<String> hatirlatmalar = [];
  bool kvkkKabul = false;
  bool acikRizaKabul = false;

  // ── Step 1 Setters ────────────────────────────────────────────────────────────
  void updateAd(String v) {
    ad = v;
    notifyListeners();
  }

  void updateSoyad(String v) {
    soyad = v;
    notifyListeners();
  }

  void updateTc(String v) {
    tc = v;
    tcCheckState = TcCheckState.idle;
    tcCheckMessage = null;
    notifyListeners();
  }

  void updateEmail(String v) {
    email = v;
    notifyListeners();
  }

  void updateTelefon(String v) {
    telefon = v;
    notifyListeners();
  }

  void updateDogumTarihi(String v) {
    dogumTarihi = v;
    notifyListeners();
  }

  void updateCinsiyet(String v) {
    cinsiyet = v;
    notifyListeners();
  }

  void updateAdres(String v) {
    adres = v;
    notifyListeners();
  }

  /// TC kimliğini async doğrula (form tamamlandığında çağrılır)
  Future<void> checkTcAsync() async {
    if (tc.length != 11) return;
    tcCheckState = TcCheckState.checking;
    tcCheckMessage = null;
    notifyListeners();

    final result = await TcValidationService.validate(tc);
    tcCheckState =
        result.isValid ? TcCheckState.valid : TcCheckState.invalid;
    tcCheckMessage = result.message;
    notifyListeners();
  }

  // ── Step 2 Setters ────────────────────────────────────────────────────────────
  void updateSigortaTuru(String v) {
    sigortaTuru = v;
    if (v != 'Özel Sigorta') sigortaFirma = '';
    notifyListeners();
  }

  void updateSigortaFirma(String v) {
    sigortaFirma = v;
    notifyListeners();
  }

  void toggleKronikHastalik(String h) {
    final list = List<String>.from(kronikHastaliklar);
    if (list.contains(h)) {
      list.remove(h);
    } else {
      list.add(h);
    }
    kronikHastaliklar = list;
    notifyListeners();
  }

  void addIlac(String ilac) {
    if (ilac.trim().isNotEmpty) {
      kullanilanIlaclar = [...kullanilanIlaclar, ilac.trim()];
      notifyListeners();
    }
  }

  void removeIlac(int index) {
    final list = List<String>.from(kullanilanIlaclar);
    list.removeAt(index);
    kullanilanIlaclar = list;
    notifyListeners();
  }

  void updateAlerjisi(bool v) {
    alerjisi = v;
    if (!v) alerjiAciklama = '';
    notifyListeners();
  }

  void updateAlerjiAciklama(String v) {
    alerjiAciklama = v;
    notifyListeners();
  }

  // ── Step 3 Setters ────────────────────────────────────────────────────────────
  void updateSehir(String v) {
    sehir = v;
    hastane = '';
    bolum = '';
    doktorId = '';
    selectedDoctor = null;
    sehirError = null;
    hastaneError = null;
    bolumError = null;
    doktorError = null;
    notifyListeners();
  }

  void updateHastane(String v) {
    hastane = v;
    bolum = '';
    doktorId = '';
    selectedDoctor = null;
    hastaneError = null;
    bolumError = null;
    doktorError = null;
    notifyListeners();
  }

  void updateBolum(String v) {
    bolum = v;
    doktorId = '';
    selectedDoctor = null;
    bolumError = null;
    doktorError = null;
    notifyListeners();
  }

  void updateDoktor(DoctorModel doctor) {
    doktorId = doctor.id;
    selectedDoctor = doctor;
    doktorError = null;
    notifyListeners();
  }

  bool validateStep3() {
    bool valid = true;
    sehirError = sehir.isEmpty ? 'Şehir seçimi zorunludur' : null;
    hastaneError = hastane.isEmpty ? 'Hastane seçimi zorunludur' : null;
    bolumError = bolum.isEmpty ? 'Bölüm seçimi zorunludur' : null;
    doktorError = doktorId.isEmpty ? 'Doktor seçimi zorunludur' : null;
    if (sehirError != null ||
        hastaneError != null ||
        bolumError != null ||
        doktorError != null) {
      valid = false;
    }
    notifyListeners();
    return valid;
  }

  // ── Step 4 Setters ────────────────────────────────────────────────────────────
  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    selectedSaat = '';
    tarihError = null;
    saatError = null;
    notifyListeners();
  }

  void updateSelectedSaat(String saat) {
    selectedSaat = saat;
    saatError = null;
    notifyListeners();
  }

  void updateAcilRandevu(bool v) {
    acilRandevu = v;
    notifyListeners();
  }

  void updateNotlar(String v) {
    notlar = v;
    notifyListeners();
  }

  bool validateStep4() {
    bool valid = true;
    tarihError = selectedDate == null ? 'Tarih seçimi zorunludur' : null;
    saatError = selectedSaat.isEmpty ? 'Saat seçimi zorunludur' : null;
    if (tarihError != null || saatError != null) valid = false;
    notifyListeners();
    return valid;
  }

  // ── Step 5 Setters ────────────────────────────────────────────────────────────
  void updateKanTahlili(bool v) {
    kanTahlili = v;
    notifyListeners();
  }

  void updateMr(bool v) {
    mr = v;
    notifyListeners();
  }

  void updateRontgen(bool v) {
    rontgen = v;
    notifyListeners();
  }

  void incrementRefakatci() {
    if (refakatciSayisi < 3) {
      refakatciSayisi++;
      notifyListeners();
    }
  }

  void decrementRefakatci() {
    if (refakatciSayisi > 0) {
      refakatciSayisi--;
      notifyListeners();
    }
  }

  void updateUlasimYardimi(String v) {
    ulasimYardimi = v;
    notifyListeners();
  }

  void toggleHatirlatma(String type) {
    final list = List<String>.from(hatirlatmalar);
    if (list.contains(type)) {
      list.remove(type);
    } else {
      list.add(type);
    }
    hatirlatmalar = list;
    notifyListeners();
  }

  void updateKvkkKabul(bool v) {
    kvkkKabul = v;
    notifyListeners();
  }

  void updateAcikRizaKabul(bool v) {
    acikRizaKabul = v;
    notifyListeners();
  }

  // ── Wizard Navigation ─────────────────────────────────────────────────────────
  void nextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners();
      _saveDraft();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 5) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // ── Submit ────────────────────────────────────────────────────────────────────
  Future<void> submitAppointment() async {
    _isSubmitting = true;
    notifyListeners();

    // Mock submission delay
    await Future.delayed(const Duration(seconds: 2));

    _appointmentId = const Uuid().v4().substring(0, 8).toUpperCase();
    _isSubmitting = false;
    _isSubmitted = true;
    notifyListeners();

    await DraftService.clearDraft();
  }

  // ── Toplam Fiyat ──────────────────────────────────────────────────────────────
  double get toplamFiyat => MockData.hesaplaToplam(
        kanTahlili: kanTahlili,
        mr: mr,
        rontgen: rontgen,
        refakatciSayisi: refakatciSayisi,
      );

  // ── Draft Save / Load ─────────────────────────────────────────────────────────
  void _saveDraft() {
    DraftService.saveDraft(toJson());
  }

  Map<String, dynamic> toJson() => {
        'ad': ad,
        'soyad': soyad,
        'tc': tc,
        'email': email,
        'telefon': telefon,
        'dogumTarihi': dogumTarihi,
        'cinsiyet': cinsiyet,
        'adres': adres,
        'sigortaTuru': sigortaTuru,
        'sigortaFirma': sigortaFirma,
        'kronikHastaliklar': kronikHastaliklar,
        'kullanilanIlaclar': kullanilanIlaclar,
        'alerjisi': alerjisi,
        'alerjiAciklama': alerjiAciklama,
        'sehir': sehir,
        'hastane': hastane,
        'bolum': bolum,
        'doktorId': doktorId,
        'doktorAdi': selectedDoctor?.fullName ?? '',
        'selectedDate': selectedDate?.toIso8601String(),
        'selectedSaat': selectedSaat,
        'acilRandevu': acilRandevu,
        'notlar': notlar,
        'kanTahlili': kanTahlili,
        'mr': mr,
        'rontgen': rontgen,
        'refakatciSayisi': refakatciSayisi,
        'ulasimYardimi': ulasimYardimi,
        'hatirlatmalar': hatirlatmalar,
        'kvkkKabul': kvkkKabul,
        'acikRizaKabul': acikRizaKabul,
        'currentStep': _currentStep,
      };

  Future<void> loadDraft() async {
    final json = await DraftService.loadDraft();
    if (json == null) return;
    _loadFromJson(json);
  }

  void _loadFromJson(Map<String, dynamic> json) {
    ad = json['ad'] ?? '';
    soyad = json['soyad'] ?? '';
    tc = json['tc'] ?? '';
    email = json['email'] ?? '';
    telefon = json['telefon'] ?? '';
    dogumTarihi = json['dogumTarihi'] ?? '';
    cinsiyet = json['cinsiyet'] ?? '';
    adres = json['adres'] ?? '';
    sigortaTuru = json['sigortaTuru'] ?? '';
    sigortaFirma = json['sigortaFirma'] ?? '';
    kronikHastaliklar =
        List<String>.from(json['kronikHastaliklar'] ?? []);
    kullanilanIlaclar =
        List<String>.from(json['kullanilanIlaclar'] ?? []);
    alerjisi = json['alerjisi'] ?? false;
    alerjiAciklama = json['alerjiAciklama'] ?? '';
    sehir = json['sehir'] ?? '';
    hastane = json['hastane'] ?? '';
    bolum = json['bolum'] ?? '';
    doktorId = json['doktorId'] ?? '';
    if (json['selectedDate'] != null) {
      selectedDate = DateTime.tryParse(json['selectedDate']);
    }
    selectedSaat = json['selectedSaat'] ?? '';
    acilRandevu = json['acilRandevu'] ?? false;
    notlar = json['notlar'] ?? '';
    kanTahlili = json['kanTahlili'] ?? false;
    mr = json['mr'] ?? false;
    rontgen = json['rontgen'] ?? false;
    refakatciSayisi = json['refakatciSayisi'] ?? 0;
    ulasimYardimi = json['ulasimYardimi'] ?? '';
    hatirlatmalar = List<String>.from(json['hatirlatmalar'] ?? []);
    kvkkKabul = json['kvkkKabul'] ?? false;
    acikRizaKabul = json['acikRizaKabul'] ?? false;
    _currentStep = json['currentStep'] ?? 0;
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────────
  void reset() {
    ad = '';
    soyad = '';
    tc = '';
    email = '';
    telefon = '';
    dogumTarihi = '';
    cinsiyet = '';
    adres = '';
    tcCheckState = TcCheckState.idle;
    tcCheckMessage = null;
    sigortaTuru = '';
    sigortaFirma = '';
    kronikHastaliklar = [];
    kullanilanIlaclar = [];
    alerjisi = false;
    alerjiAciklama = '';
    sehir = '';
    hastane = '';
    bolum = '';
    doktorId = '';
    selectedDoctor = null;
    selectedDate = null;
    selectedSaat = '';
    acilRandevu = false;
    notlar = '';
    kanTahlili = false;
    mr = false;
    rontgen = false;
    refakatciSayisi = 0;
    ulasimYardimi = '';
    hatirlatmalar = [];
    kvkkKabul = false;
    acikRizaKabul = false;
    _currentStep = 0;
    _isSubmitting = false;
    _isSubmitted = false;
    _appointmentId = null;
    notifyListeners();
  }
}
