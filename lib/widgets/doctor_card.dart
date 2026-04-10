import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/doctor_model.dart';
import '../utils/constants.dart';

/// Premium doktor secim karti
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  final DoctorModel doctor;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('doktor_item_$index'),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryUltraLight
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    spreadRadius: -4,
                  )
                ]
              : AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 14),
            Expanded(child: _buildInfo(context)),
            _buildTrailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_avatarColor(index), _avatarColorEnd(index)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _avatarColor(index).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          )
        ],
      ),
      child: Center(
        child: Text(
          doctor.initials,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.fullName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          doctor.uzmanlik,
          style: GoogleFonts.poppins(
            color: AppColors.subtitle,
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Rating badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFED7AA),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 13, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 3),
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${doctor.reviewCount})',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.subtitle,
              ),
            ),
            if (doctor.tecrube.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  doctor.tecrube,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.secondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    if (isSelected) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: AppColors.buttonLinearGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.subtitle,
        size: 18,
      ),
    );
  }

  Color _avatarColor(int i) {
    const colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Color(0xFF0891B2),
      Color(0xFF059669),
      Color(0xFFEA580C),
    ];
    return colors[i % colors.length];
  }

  Color _avatarColorEnd(int i) {
    const colors = [
      AppColors.primaryLight,
      AppColors.secondaryLight,
      AppColors.accentLight,
      Color(0xFF22D3EE),
      Color(0xFF34D399),
      Color(0xFFFB923C),
    ];
    return colors[i % colors.length];
  }
}
