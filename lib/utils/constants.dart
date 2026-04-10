import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Colors ─────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryUltraLight = Color(0xFFEFF6FF);

  // ── Secondary / Teal ──────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF67E8F9);
  static const Color secondaryDark = Color(0xFF0891B2);

  // ── Accent / Violet ───────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);

  // ── Status ────────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // ── Backgrounds ───────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ── Text ──────────────────────────────────────────────────────────────────────
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color bodyText = Color(0xFF334155);
  static const Color subtitle = Color(0xFF94A3B8);

  // ── UI Elements ───────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color inputFill = Color(0xFFF8FAFC);
  static const Color disabled = Color(0xFFCBD5E1);
  static const Color disabledBg = Color(0xFFF1F5F9);
  static const Color acilColor = Color(0xFFEF4444);
  static const Color acilBg = Color(0xFFFEF2F2);

  // ── Glass Effect Colors ────────────────────────────────────────────────────────
  static const Color glassBorder = Color(0x30FFFFFF);
  static const Color glassBackground = Color(0x18FFFFFF);
  static const Color glassShadow = Color(0x08000000);

  // ── Gradients ──────────────────────────────────────────────────────────────────
  static const List<Color> brandGradient = [
    Color(0xFF1D4ED8),
    Color(0xFF2563EB),
    Color(0xFF60A5FA),
  ];
  static const List<Color> buttonGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];
  static const List<Color> successGradientColors = [
    Color(0xFF059669),
    Color(0xFF10B981),
  ];
  static const List<Color> accentGradient = [
    Color(0xFF7C3AED),
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
  ];
  static const List<Color> warmGradient = [
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
  ];

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
      Color(0xFF1D4ED8),
    ],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient headerGradientAlt = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF312E81),
      Color(0xFF4F46E5),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient buttonLinearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  );

  static const LinearGradient successLinearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient cardShimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x00FFFFFF),
      Color(0x08FFFFFF),
      Color(0x00FFFFFF),
    ],
  );
}

class AppDimensions {
  AppDimensions._();

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 12.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusPill = 100.0;

  static const double cardElevation = 0.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double avatarSize = 52.0;
}

class AppStrings {
  AppStrings._();

  static const String appName = 'MediBook';
  static const String appTagline = 'Akilli Hastane Randevu';

  static const List<String> stepTitles = [
    'Kisisel Bilgiler',
    'Sigorta & Saglik',
    'Bolum & Doktor',
    'Tarih & Saat',
    'Ek Hizmetler',
    'Ozet & Onay',
  ];

  static const List<String> stepSubtitles = [
    'Kimlik ve iletisim bilgileri',
    'Sigorta ve saglik durumu',
    'Hastane ve doktor secimi',
    'Randevu gunu ve saati',
    'Ek tetkik ve onaylar',
    'Son kontrol ve onay',
  ];

  static const List<IconData> stepIcons = [
    Icons.person_rounded,
    Icons.health_and_safety_rounded,
    Icons.local_hospital_rounded,
    Icons.calendar_month_rounded,
    Icons.add_circle_rounded,
    Icons.fact_check_rounded,
  ];
}

/// Shared input decoration
class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration build({
    required String label,
    String? hint,
    IconData? prefixIcon,
    Widget? suffix,
    bool hasError = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(prefixIcon, size: 20, color: AppColors.subtitle),
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 0),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.primary, width: 2),
      errorBorder: _border(AppColors.error),
      focusedErrorBorder: _border(AppColors.error, width: 2),
      labelStyle: const TextStyle(
        color: AppColors.subtitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: AppColors.subtitle.withOpacity(0.5),
        fontSize: 14,
      ),
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      counterText: '',
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Shared box shadow presets
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 32,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: AppColors.success.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];
}
