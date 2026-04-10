import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _contentController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late Animation<double> _checkScale;
  late Animation<double> _contentFade;
  late Animation<double> _contentSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _contentSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _checkController.forward();
        _confettiController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appointmentId = provider.appointmentId ?? '—';

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF1D4ED8),
                  AppColors.background,
                ],
                stops: [0.0, 0.15, 0.42, 0.42],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Top gradient section ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                    child: Column(
                      children: [
                        // Animated checkmark with rings
                        _buildCheckmark(),
                        const SizedBox(height: 24),
                        // Title
                        Text(
                          'Randevunuz Onaylandi!',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Detaylar e-posta ve SMS ile gonderilecektir.',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom content card ─────────────────────────
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _contentController,
                        builder: (_, child) => Opacity(
                          opacity: _contentFade.value,
                          child: Transform.translate(
                            offset: Offset(0, _contentSlide.value),
                            child: child,
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(20, 28, 20, 24),
                          child: Column(
                            children: [
                              _buildIdCard(context, appointmentId),
                              const SizedBox(height: 16),
                              _buildDetailCard(context, provider),
                              const SizedBox(height: 24),
                              _buildPrimaryButton(context, provider),
                              const SizedBox(height: 10),
                              _buildSecondaryButton(context),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti overlay
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (_, _) => CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _ConfettiPainter(
                  progress: _confettiController.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmark() {
    return ScaleTransition(
      scale: _checkScale,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) => Transform.scale(
          scale: _pulse.value,
          child: child,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 2,
                ),
              ),
            ),
            // Middle ring
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
            ),
            // Inner circle
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCard(BuildContext context, String appointmentId) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: appointmentId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.copy_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Text('Randevu numarasi kopyalandi',
                    style: GoogleFonts.poppins()),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.buttonLinearGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: const Icon(Icons.confirmation_number_outlined,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RANDEVU NUMARASI',
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitle,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#$appointmentId',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryUltraLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.copy_rounded,
                  size: 18, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context, AppointmentProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonLinearGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      size: 16, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  'Randevu Detaylari',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(
              height: 1, thickness: 0.5, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _detailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Hasta',
                  value: '${provider.ad} ${provider.soyad}',
                ),
                if (provider.selectedDoctor != null) ...[
                  const _DetailDivider(),
                  _detailRow(
                    icon: Icons.medical_services_outlined,
                    label: 'Doktor',
                    value: provider.selectedDoctor!.fullName,
                  ),
                ],
                const _DetailDivider(),
                _detailRow(
                  icon: Icons.local_hospital_outlined,
                  label: 'Hastane',
                  value: provider.hastane,
                ),
                const _DetailDivider(),
                _detailRow(
                  icon: Icons.account_tree_outlined,
                  label: 'Bolum',
                  value: provider.bolum,
                ),
                if (provider.selectedDate != null) ...[
                  const _DetailDivider(),
                  _detailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Tarih & Saat',
                    value:
                        '${DateFormat('dd MMMM yyyy', 'tr_TR').format(provider.selectedDate!)}, ${provider.selectedSaat}',
                  ),
                ],
                const _DetailDivider(),
                _detailRow(
                  icon: Icons.payments_outlined,
                  label: 'Toplam',
                  value:
                      AppFormatters.formatCurrency(provider.toplamFiyat),
                  valueColor: AppColors.primary,
                  valueBold: true,
                ),
                if (provider.acilRandevu) ...[
                  const _DetailDivider(),
                  _detailRow(
                    icon: Icons.emergency_outlined,
                    label: 'Oncelik',
                    value: 'Acil Randevu',
                    valueColor: AppColors.acilColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryUltraLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppColors.subtitle,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: valueColor ?? AppColors.bodyText,
                  fontSize: 14,
                  fontWeight:
                      valueBold ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
      BuildContext context, AppointmentProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonLinearGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: AppShadows.primaryGlow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => provider.reset(),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            splashColor: Colors.white.withOpacity(0.15),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline_rounded,
                      size: 22, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Yeni Randevu Al',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Randevularim sayfasina yonlendiriliyor...',
                  style: GoogleFonts.poppins()),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.calendar_today_outlined, size: 18),
        label: Text(
          'Randevularimi Goruntule',
          style: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child:
          Divider(height: 1, thickness: 0.5, color: AppColors.border),
    );
  }
}

/// Custom painter for confetti particles
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});

  final double progress;
  final Random _random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    const particleCount = 60;
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
    ];

    for (int i = 0; i < particleCount; i++) {
      final seed = _random.nextDouble();
      final seed2 = _random.nextDouble();
      final seed3 = _random.nextDouble();
      final colorIndex = i % colors.length;

      final x = seed * size.width;
      final startY = -20.0 + seed2 * size.height * 0.3;
      final endY = size.height * 0.4 + seed3 * size.height * 0.6;

      final currentY = startY + (endY - startY) * progress;
      final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.8;

      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = colors[colorIndex].withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final particleSize = 3.0 + seed * 5.0;

      // Rotation & horizontal drift
      final drift = sin(progress * pi * 3 + seed * pi * 2) * 30;

      canvas.save();
      canvas.translate(x + drift, currentY);
      canvas.rotate(progress * pi * 4 * (seed > 0.5 ? 1 : -1));

      if (i % 3 == 0) {
        // Rectangle confetti
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero,
                width: particleSize * 1.5,
                height: particleSize),
            const Radius.circular(1),
          ),
          paint,
        );
      } else if (i % 3 == 1) {
        // Circle confetti
        canvas.drawCircle(Offset.zero, particleSize / 2, paint);
      } else {
        // Diamond confetti
        final path = Path()
          ..moveTo(0, -particleSize)
          ..lineTo(particleSize * 0.6, 0)
          ..lineTo(0, particleSize)
          ..lineTo(-particleSize * 0.6, 0)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
