import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class StepHeader extends StatefulWidget {
  const StepHeader({super.key, required this.currentStep});

  final int currentStep;
  static const int totalSteps = 6;

  @override
  State<StepHeader> createState() => _StepHeaderState();
}

class _StepHeaderState extends State<StepHeader>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _floatingController;
  late Animation<double> _progressAnimation;

  int _previousStep = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _progressAnimation = Tween<double>(
      begin: 0,
      end: (widget.currentStep + 1) / StepHeader.totalSteps,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _progressController.forward();
  }

  @override
  void didUpdateWidget(StepHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousStep = oldWidget.currentStep;
      _progressAnimation = Tween<double>(
        begin: (_previousStep + 1) / StepHeader.totalSteps,
        end: (widget.currentStep + 1) / StepHeader.totalSteps,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: Stack(
        children: [
          // Floating orbs background
          ..._buildFloatingOrbs(),
          // Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 12),
              _buildStepIndicators(),
              const SizedBox(height: 12),
              _buildAnimatedProgressBar(),
              const SizedBox(height: 6),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingOrbs() {
    return [
      AnimatedBuilder(
        animation: _floatingController,
        builder: (_, _) {
          final t = _floatingController.value;
          return Positioned(
            right: -20 + sin(t * 2 * pi) * 10,
            top: -10 + cos(t * 2 * pi) * 8,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _floatingController,
        builder: (_, _) {
          final t = _floatingController.value;
          return Positioned(
            left: -30 + cos(t * 2 * pi) * 12,
            bottom: -20 + sin(t * 2 * pi) * 6,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.12),
                    AppColors.secondary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // Brand pill with glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.local_hospital_rounded,
                          color: Colors.white, size: 13),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      AppStrings.appName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Step title & subtitle with animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) {
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey(widget.currentStep),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.stepTitles[widget.currentStep],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.stepSubtitles[widget.currentStep],
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Animated step counter
          _buildStepCounter(),
        ],
      ),
    );
  }

  Widget _buildStepCounter() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (_, child) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
                color: Colors.white.withOpacity(0.25), width: 1.5),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 2.5,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Step number
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.currentStep + 1}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/ ${StepHeader.totalSteps}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(StepHeader.totalSteps, (i) {
          final isDone = i < widget.currentStep;
          final isCurrent = i == widget.currentStep;
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: i < StepHeader.totalSteps - 1 ? 6 : 0),
              child: GestureDetector(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.white.withOpacity(0.2)
                        : isCurrent
                            ? Colors.white.withOpacity(0.15)
                            : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCurrent
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                      width: isCurrent ? 1.5 : 0.5,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isDone
                          ? Icon(
                              Icons.check_rounded,
                              key: const ValueKey('check'),
                              size: 14,
                              color: Colors.white.withOpacity(0.9),
                            )
                          : Icon(
                              AppStrings.stepIcons[i],
                              key: ValueKey('icon_$i'),
                              size: 14,
                              color: isCurrent
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (_, _) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Track
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFF93C5FD)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
