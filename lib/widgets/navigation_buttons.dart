import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// Wizard alt navigasyon butonları (Geri / İleri / Onayla)
class NavigationButtons extends StatefulWidget {
  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.onNext,
    this.isLoading = false,
  });

  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isLoading;

  static const int totalSteps = 6;

  @override
  State<NavigationButtons> createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  bool get isFirstStep => widget.currentStep == 0;
  bool get isLastStep => widget.currentStep == NavigationButtons.totalSteps - 1;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            14 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: AppColors.border, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Geri butonu ──────────────────────────────────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isFirstStep ? 0.35 : 1.0,
                child: SizedBox(
                  height: AppDimensions.buttonHeight,
                  width: AppDimensions.buttonHeight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: const ValueKey('btn_geri'),
                      onTap: isFirstStep ? null : widget.onBack,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── İleri / Onayla butonu ────────────────────────────────
              Expanded(
                child: isLastStep
                    ? _buildConfirmButton()
                    : _buildNextButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonLinearGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: AppShadows.primaryGlow,
        ),
        child: Stack(
          children: [
            // Shimmer overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (_, _) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: [
                          (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                          _shimmerController.value,
                          (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                key: const ValueKey('btn_ileri'),
                onTap: widget.onNext,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
                splashColor: Colors.white.withOpacity(0.15),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'İleri',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.successLinearGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: AppShadows.successGlow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const ValueKey('btn_onayla'),
            onTap: widget.isLoading ? null : widget.onNext,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            splashColor: Colors.white.withOpacity(0.15),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 22, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    widget.isLoading ? 'Onaylanıyor...' : 'Randevuyu Onayla',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
