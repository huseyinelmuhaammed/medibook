import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/step_header.dart';
import '../widgets/navigation_buttons.dart';
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
  final GlobalKey<Step1PersonalState> _step1Key = GlobalKey<Step1PersonalState>();
  final GlobalKey<Step2InsuranceState> _step2Key = GlobalKey<Step2InsuranceState>();
  final GlobalKey<Step4DateTimeState> _step4Key = GlobalKey<Step4DateTimeState>();
  final GlobalKey<Step5ServicesState> _step5Key = GlobalKey<Step5ServicesState>();

  static const List<Map<String, String>> _stepInfo = [
    {'title': 'Kişisel Bilgiler', 'description': 'Ad, soyad ve iletişim bilgilerinizi girin'},
    {'title': 'Sigorta & Sağlık', 'description': 'Sigorta ve alerji bilgilerinizi belirtin'},
    {'title': 'Bölüm & Doktor', 'description': 'Hastane, bölüm ve doktor seçimi yapın'},
    {'title': 'Tarih & Saat', 'description': 'Randevu tarihi ve saati seçin'},
    {'title': 'Ek Hizmetler', 'description': 'Ek hizmetler ve onaylar'},
    {'title': 'Özet & Onay', 'description': 'Randevu bilgilerinizi gözden geçirin'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadDraft();
    });
  }

  Future<bool> _validateCurrentStep(int step, AppointmentProvider provider) async {
    switch (step) {
      case 0:
        return _step1Key.currentState?.validate() ?? false;
      case 1:
        return _step2Key.currentState?.validate() ?? true;
      case 2:
        final appt = provider.currentAppointment;
        if (appt.sehir.isEmpty) {
          _showError('Lütfen şehir seçin');
          return false;
        }
        if (appt.hastane.isEmpty) {
          _showError('Lütfen hastane seçin');
          return false;
        }
        if (appt.bolum.isEmpty) {
          _showError('Lütfen bölüm seçin');
          return false;
        }
        if (appt.doktorId.isEmpty) {
          _showError('Lütfen doktor seçin');
          return false;
        }
        return true;
      case 3:
        return _step4Key.currentState?.validate() ?? false;
      case 4:
        return _step5Key.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleNext() async {
    final provider = context.read<AppointmentProvider>();
    final isValid = await _validateCurrentStep(provider.currentStep, provider);
    if (isValid) {
      provider.nextStep();
    }
  }

  void _handleBack() {
    context.read<AppointmentProvider>().previousStep();
  }

  Future<void> _handleConfirm() async {
    final provider = context.read<AppointmentProvider>();
    final appt = provider.currentAppointment;
    if (!appt.kvkkOnay || !appt.acikRizaOnay) {
      _showError('KVKK ve Açık Rıza onaylarını kabul etmeniz gerekmektedir');
      return;
    }
    final success = await provider.submitAppointment();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessScreen(appointment: provider.currentAppointment),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        final step = provider.currentStep;
        return Scaffold(
          body: Column(
            children: [
              StepHeader(
                currentStep: step,
                title: _stepInfo[step]['title']!,
                description: _stepInfo[step]['description']!,
              ),
              Expanded(
                child: IndexedStack(
                  index: step,
                  children: [
                    Step1Personal(key: _step1Key),
                    Step2Insurance(key: _step2Key),
                    const Step3Department(),
                    Step4DateTime(key: _step4Key),
                    Step5Services(key: _step5Key),
                    const Step6Summary(),
                  ],
                ),
              ),
              NavigationButtons(
                currentStep: step,
                onBack: _handleBack,
                onNext: _handleNext,
                onConfirm: _handleConfirm,
                isLoading: provider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
