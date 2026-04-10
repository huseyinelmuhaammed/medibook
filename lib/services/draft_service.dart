import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Form taslağını SharedPreferences ile kaydeder ve yükler.
class DraftService {
  DraftService._();

  static const String _draftKey = 'medibook_appointment_draft';

  /// Taslağı kaydet
  static Future<void> saveDraft(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_draftKey, jsonEncode(data));
    } catch (_) {
      // Kaydetme hatası sessizce görmezden gelinir
    }
  }

  /// Taslağı yükle; yoksa null döner
  static Future<Map<String, dynamic>?> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Taslağı sil (randevu onaylandıktan sonra çağrılır)
  static Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (_) {}
  }

  /// Taslak var mı?
  static Future<bool> hasDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_draftKey);
    } catch (_) {
      return false;
    }
  }
}
