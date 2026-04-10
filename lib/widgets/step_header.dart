import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final String title;
  final String description;
  final int totalSteps;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.title,
    required this.description,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentStep + 1) / totalSteps;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adım ${currentStep + 1} / $totalSteps',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
              Text(
                '${((progress) * 100).toInt()}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
