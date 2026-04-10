import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import '../services/tc_validation_service.dart';
import '../utils/constants.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/step_header.dart';
import 'steps/step1_personal.dart';
import 'steps/step2_insurance.dart';
import 'steps/step3_department.dart';
import 'steps/step4_datetime.dart';
import 'steps/step5_services.dart';
import 'steps/step6_summary.dart';
import 'success_screen.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _previousStep = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        // Onay tamamlandiysa basari ekranini goster
        if (provider.isSubmitted) {
          return const SuccessScreen();
        }

        final isForward = provider.currentStep >= _previousStep;

        // Adim degistiginde onceki adimi kaydet
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_previousStep != provider.currentStep) {
            setState(() {
              _previousStep = provider.currentStep;
            });
          }
        });

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Adim basligi ve progress bar ──────────────────────
                StepHeader(currentStep: provider.currentStep),

                // ── Adim icerigi (animated transition) ────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final slideOffset = isForward
                          ? Tween<Offset>(
                              begin: const Offset(0.06, 0),
                              end: Offset.zero,
                            )
                          : Tween<Offset>(
                              begin: const Offset(-0.06, 0),
                              end: Offset.zero,
                            );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideOffset.animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildStepContent(provider.currentStep),
                  ),
                ),

                // ── Navigasyon butonlari ──────────────────────────────
                NavigationButtons(
                  currentStep: provider.currentStep,
                  isLoading: provider.isSubmitting,
                  onBack: () => _handleBack(context, provider),
                  onNext: () => _handleNext(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const Step1Personal(key: ValueKey(0));
      case 1:
        return const Step2Insurance(key: ValueKey(1));
      case 2:
        return const Step3Department(key: ValueKey(2));
      case 3:
        return const Step4DateTime(key: ValueKey(3));
      case 4:
        return const Step5Services(key: ValueKey(4));
      case 5:
        return const Step6Summary(key: ValueKey(5));
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleBack(
      BuildContext context, AppointmentProvider provider) {
    provider.previousStep();
  }

  Future<void> _handleNext(
      BuildContext context, AppointmentProvider provider) async {
    switch (provider.currentStep) {
      case 0:
        _handleStep1(context, provider);
        break;
      case 1:
        _handleStep2(context, provider);
        break;
      case 2:
        _handleStep3(context, provider);
        break;
      case 3:
        _handleStep4(context, provider);
        break;
      case 4:
        _handleStep5(context, provider);
        break;
      case 5:
        await _handleStep6(context, provider);
        break;
    }
  }

  void _handleStep1(BuildContext context, AppointmentProvider provider) {
    final formValid =
        provider.step1FormKey.currentState?.validate() ?? false;
    if (!formValid) {
      _showErrorSnack(context, 'Lutfen tum zorunlu alanlari doldurun');
      return;
    }

    if (provider.cinsiyet.isEmpty) {
      _showErrorSnack(context, 'Lutfen cinsiyet secimi yapin');
      return;
    }

    provider.step1FormKey.currentState?.save();
    provider.nextStep();

    if (provider.tcCheckState == TcCheckState.idle) {
      provider.checkTcAsync();
    }
  }

  void _handleStep2(BuildContext context, AppointmentProvider provider) {
    final formValid =
        provider.step2FormKey.currentState?.validate() ?? false;
    if (!formValid) {
      _showErrorSnack(context,
          'Lutfen zorunlu alanlari doldurun (Ozel sigorta / Alerji aciklamasi)');
      return;
    }
    provider.step2FormKey.currentState?.save();
    provider.nextStep();
  }

  void _handleStep3(BuildContext context, AppointmentProvider provider) {
    final valid = provider.validateStep3();
    if (!valid) {
      _showErrorSnack(
          context, 'Lutfen sehir, hastane, bolum ve doktor secin');
      return;
    }
    provider.nextStep();
  }

  void _handleStep4(BuildContext context, AppointmentProvider provider) {
    final formValid =
        provider.step4FormKey.currentState?.validate() ?? true;
    final dateTimeValid = provider.validateStep4();

    if (!formValid || !dateTimeValid) {
      _showErrorSnack(
          context, 'Lutfen randevu tarihi ve saati secin');
      return;
    }
    provider.nextStep();
  }

  void _handleStep5(BuildContext context, AppointmentProvider provider) {
    if (!provider.kvkkKabul || !provider.acikRizaKabul) {
      _showErrorSnack(
          context, 'KVKK ve Acik Riza onaylari zorunludur');
      return;
    }
    provider.nextStep();
  }

  Future<void> _handleStep6(
      BuildContext context, AppointmentProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: AppColors.success, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Randevuyu Onayla',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Randevu bilgilerinizi onayliyor musunuz? Onayladiginizda size bilgilendirme mesaji gonderilecektir.',
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Iptal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Text(
              'Onayla',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.submitAppointment();
    }
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
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
              child:
                  const Icon(Icons.error_outline, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message,
                    style: GoogleFonts.poppins(fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        elevation: 8,
      ),
    );
  }
}
