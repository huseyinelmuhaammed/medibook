import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';

/// Premium pill-shaped 30-dakikalik saat dilimi izgarasi
class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.selectedDate,
    required this.selectedSaat,
    required this.onSlotTap,
  });

  final DateTime selectedDate;
  final String selectedSaat;
  final ValueChanged<String> onSlotTap;

  @override
  Widget build(BuildContext context) {
    final slots = MockData.generateSlots();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((saat) {
        final isOccupied = MockData.isSlotOccupied(selectedDate, saat);
        final isSelected = selectedSaat == saat;

        return _SlotTile(
          saat: saat,
          isOccupied: isOccupied,
          isSelected: isSelected,
          onTap: isOccupied ? null : () => onSlotTap(saat),
        );
      }).toList(),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.saat,
    required this.isOccupied,
    required this.isSelected,
    required this.onTap,
  });

  final String saat;
  final bool isOccupied;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('slot_$saat'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonLinearGradient : null,
          color: isOccupied
              ? AppColors.disabledBg
              : isSelected
                  ? null
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          border: Border.all(
            color: isOccupied
                ? AppColors.border
                : isSelected
                    ? Colors.transparent
                    : AppColors.border,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              saat,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                letterSpacing: 0.3,
                color: isOccupied
                    ? AppColors.disabled
                    : isSelected
                        ? Colors.white
                        : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOccupied && !isSelected)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  isOccupied
                      ? 'Dolu'
                      : isSelected
                          ? 'Secildi'
                          : 'Bos',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    color: isOccupied
                        ? AppColors.disabled
                        : isSelected
                            ? Colors.white.withOpacity(0.88)
                            : AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
