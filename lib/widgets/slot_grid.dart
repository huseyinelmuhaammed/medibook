import 'package:flutter/material.dart';

class SlotGrid extends StatelessWidget {
  final String? selectedSlot;
  final List<String> doluSlotlar;
  final ValueChanged<String> onSlotSelected;

  const SlotGrid({
    super.key,
    this.selectedSlot,
    required this.doluSlotlar,
    required this.onSlotSelected,
  });

  static List<String> get allSlots {
    final slots = <String>[];
    for (int hour = 9; hour <= 16; hour++) {
      for (int minute in [0, 30]) {
        final h = hour.toString().padLeft(2, '0');
        final m = minute.toString().padLeft(2, '0');
        slots.add('$h:$m');
      }
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slots = allSlots;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isDolu = doluSlotlar.contains(slot);
        final isSelected = selectedSlot == slot;

        Color backgroundColor;
        Color textColor;
        Color borderColor;

        if (isDolu) {
          backgroundColor = theme.colorScheme.surfaceVariant;
          textColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.4);
          borderColor = theme.colorScheme.outline.withOpacity(0.3);
        } else if (isSelected) {
          backgroundColor = theme.colorScheme.primary;
          textColor = theme.colorScheme.onPrimary;
          borderColor = theme.colorScheme.primary;
        } else {
          backgroundColor = theme.colorScheme.surface;
          textColor = theme.colorScheme.onSurface;
          borderColor = theme.colorScheme.outline.withOpacity(0.5);
        }

        return InkWell(
          key: ValueKey('slot_$slot'),
          onTap: isDolu ? null : () => onSlotSelected(slot),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                decoration: isDolu ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
