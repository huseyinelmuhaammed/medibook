import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appointment_model.dart';

class DraftService {
  static const String _draftKey = 'appointment_draft';

  static Future<void> saveDraft(AppointmentModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString(_draftKey, jsonString);
  }

  static Future<AppointmentModel?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_draftKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppointmentModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }
}
