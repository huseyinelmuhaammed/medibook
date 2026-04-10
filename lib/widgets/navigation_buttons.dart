import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onConfirm;
  final bool isLoading;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    this.onBack,
    this.onNext,
    this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == 5;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            Expanded(
              child: OutlinedButton.icon(
                key: const ValueKey('btn_geri'),
                onPressed: isLoading ? null : onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Geri'),
              ),
            ),
          if (!isFirstStep) const SizedBox(width: 12),
          if (!isLastStep)
            Expanded(
              child: ElevatedButton.icon(
                key: const ValueKey('btn_ileri'),
                onPressed: isLoading ? null : onNext,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('İleri'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          if (isLastStep)
            Expanded(
              child: ElevatedButton.icon(
                key: const ValueKey('btn_onayla'),
                onPressed: isLoading ? null : onConfirm,
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(isLoading ? 'Gönderiliyor...' : 'Randevuyu Onayla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
