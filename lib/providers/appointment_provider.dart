import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../services/draft_service.dart';

class AppointmentProvider extends ChangeNotifier {
  AppointmentModel _currentAppointment = AppointmentModel(
    id: const Uuid().v4(),
  );
  int _currentStep = 0;
  bool _isLoading = false;
  Map<String, String> _validationErrors = {};

  AppointmentModel get currentAppointment => _currentAppointment;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  Map<String, String> get validationErrors => Map.unmodifiable(_validationErrors);

  void setStep(int step) {
    if (step >= 0 && step <= 5) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void updateField(String field, dynamic value) {
    switch (field) {
      case 'ad':
        _currentAppointment = _currentAppointment.copyWith(ad: value as String);
      case 'soyad':
        _currentAppointment = _currentAppointment.copyWith(soyad: value as String);
      case 'tc':
        _currentAppointment = _currentAppointment.copyWith(tc: value as String);
      case 'email':
        _currentAppointment = _currentAppointment.copyWith(email: value as String);
      case 'telefon':
        _currentAppointment = _currentAppointment.copyWith(telefon: value as String);
      case 'dogumTarihi':
        _currentAppointment = _currentAppointment.copyWith(dogumTarihi: value as String);
      case 'adres':
        _currentAppointment = _currentAppointment.copyWith(adres: value as String);
      case 'cinsiyet':
        _currentAppointment = _currentAppointment.copyWith(cinsiyet: value as String);
      case 'sigortaTuru':
        _currentAppointment = _currentAppointment.copyWith(sigortaTuru: value as String);
      case 'sigortaFirma':
        _currentAppointment = _currentAppointment.copyWith(sigortaFirma: value as String);
      case 'alerjisi':
        _currentAppointment = _currentAppointment.copyWith(alerjisi: value as bool);
      case 'alerjiAciklama':
        _currentAppointment = _currentAppointment.copyWith(alerjiAciklama: value as String);
      case 'sehir':
        _currentAppointment = _currentAppointment.copyWith(
          sehir: value as String,
          hastane: '',
          bolum: '',
          doktorId: '',
          doktorAdi: '',
        );
      case 'hastane':
        _currentAppointment = _currentAppointment.copyWith(
          hastane: value as String,
          bolum: '',
          doktorId: '',
          doktorAdi: '',
        );
      case 'bolum':
        _currentAppointment = _currentAppointment.copyWith(
          bolum: value as String,
          doktorId: '',
          doktorAdi: '',
        );
      case 'doktorId':
        _currentAppointment = _currentAppointment.copyWith(doktorId: value as String);
      case 'doktorAdi':
        _currentAppointment = _currentAppointment.copyWith(doktorAdi: value as String);
      case 'randevuTarihi':
        _currentAppointment = _currentAppointment.copyWith(randevuTarihi: value as DateTime?);
      case 'randevuSaati':
        _currentAppointment = _currentAppointment.copyWith(randevuSaati: value as String?);
      case 'acilDurum':
        _currentAppointment = _currentAppointment.copyWith(acilDurum: value as bool);
      case 'notlar':
        _currentAppointment = _currentAppointment.copyWith(notlar: value as String);
      case 'ekHizmetler':
        _currentAppointment = _currentAppointment.copyWith(ekHizmetler: value as List<String>);
      case 'refakatciSayisi':
        _currentAppointment = _currentAppointment.copyWith(refakatciSayisi: value as int);
      case 'kvkkOnay':
        _currentAppointment = _currentAppointment.copyWith(kvkkOnay: value as bool);
      case 'acikRizaOnay':
        _currentAppointment = _currentAppointment.copyWith(acikRizaOnay: value as bool);
    }
    _saveDraft();
    notifyListeners();
  }

  void setValidationError(String field, String error) {
    _validationErrors[field] = error;
    notifyListeners();
  }

  void clearValidationError(String field) {
    _validationErrors.remove(field);
    notifyListeners();
  }

  void clearAllValidationErrors() {
    _validationErrors.clear();
    notifyListeners();
  }

  void _saveDraft() {
    DraftService.saveDraft(_currentAppointment);
  }

  Future<void> loadDraft() async {
    final draft = await DraftService.loadDraft();
    if (draft != null) {
      _currentAppointment = draft;
      notifyListeners();
    }
  }

  Future<void> clearDraft() async {
    await DraftService.clearDraft();
  }

  Future<bool> submitAppointment() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      final now = DateTime.now();
      _currentAppointment = _currentAppointment.copyWith(olusturmaTarihi: now);
      await DraftService.clearDraft();
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetAppointment() {
    _currentAppointment = AppointmentModel(id: const Uuid().v4());
    _currentStep = 0;
    _validationErrors = {};
    notifyListeners();
  }
}
