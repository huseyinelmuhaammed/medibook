import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// Modern glassmorphism-inspired section card with gradient icon badge
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.padding,
    this.color,
    this.trailing,
    this.iconGradient,
  });

  final String? title;
  final IconData? icon;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? trailing;
  final Gradient? iconGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) _buildHeader(context),
          Padding(
            padding: padding ?? const EdgeInsets.all(AppDimensions.paddingM),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: iconGradient ??
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: (iconGradient != null
                            ? AppColors.accent
                            : AppColors.primary)
                        .withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                letterSpacing: -0.2,
                fontSize: 15,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Baslik + ince separator + icerik
class DividerSectionCard extends StatelessWidget {
  const DividerSectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.child,
    this.iconGradient,
  });

  final String title;
  final IconData? icon;
  final Widget child;
  final Gradient? iconGradient;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: icon,
      iconGradient: iconGradient,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.5, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: child,
          ),
        ],
      ),
    );
  }
}
