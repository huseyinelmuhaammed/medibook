import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/section_card.dart';

class Step2Insurance extends StatefulWidget {
  const Step2Insurance({super.key});

  @override
  State<Step2Insurance> createState() => _Step2InsuranceState();
}

class _Step2InsuranceState extends State<Step2Insurance> {
  late TextEditingController _sigortaFirmaCtrl;
  late TextEditingController _alerjiCtrl;
  final TextEditingController _ilacCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = context.read<AppointmentProvider>();
    _sigortaFirmaCtrl = TextEditingController(text: p.sigortaFirma);
    _alerjiCtrl = TextEditingController(text: p.alerjiAciklama);
  }

  @override
  void dispose() {
    _sigortaFirmaCtrl.dispose();
    _alerjiCtrl.dispose();
    _ilacCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: provider.step2FormKey,
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Sigorta ──────────────────────────────────────────────
            SectionCard(
              title: 'Sigorta Bilgileri',
              icon: Icons.health_and_safety_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DropdownField(
                    label: 'Sigorta Turu *',
                    hint: 'Sigorta turunuzu secin',
                    child: DropdownButton<String>(
                      key: const ValueKey('dropdown_sigorta'),
                      value: provider.sigortaTuru.isEmpty
                          ? null
                          : provider.sigortaTuru,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      hint: Text('Secin',
                          style: GoogleFonts.poppins(
                              color: AppColors.subtitle)),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary),
                      style: GoogleFonts.poppins(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      items: MockData.sigortaTurleri
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          provider.updateSigortaTuru(v);
                          if (v != 'Özel Sigorta') {
                            _sigortaFirmaCtrl.clear();
                          }
                        }
                      },
                    ),
                  ),

                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        key: const ValueKey('input_sigorta_firma'),
                        controller: _sigortaFirmaCtrl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _inputDeco(
                          label: 'Sigorta Firmasi *',
                          hint: 'Orn: Axa Sigorta',
                          icon: Icons.business_outlined,
                        ),
                        onChanged: provider.updateSigortaFirma,
                        validator: provider.sigortaTuru == 'Özel Sigorta'
                            ? Validators.validateSigortaFirma
                            : null,
                      ),
                    ),
                    crossFadeState: provider.sigortaTuru == 'Özel Sigorta'
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                ],
              ),
            ),

            // ── Kronik Hastaliklar ───────────────────────────────────
            SectionCard(
              title: 'Kronik Hastaliklar',
              icon: Icons.monitor_heart_outlined,
              iconGradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF87171)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Varsa kronik hastaliklarinizi secin (coklu secim)',
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitle,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockData.kronikHastaliklar.map((h) {
                      final selected =
                          provider.kronikHastaliklar.contains(h);
                      return FilterChip(
                        label: Text(h),
                        selected: selected,
                        onSelected: (_) =>
                            provider.toggleKronikHastalik(h),
                        backgroundColor: AppColors.inputFill,
                        selectedColor:
                            AppColors.primary.withOpacity(0.12),
                        checkmarkColor: AppColors.primary,
                        labelStyle: GoogleFonts.poppins(
                          color: selected
                              ? AppColors.primary
                              : AppColors.bodyText,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS),
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // ── Kullanilan Ilaclar ──────────────────────────────────
            SectionCard(
              title: 'Kullanilan Ilaclar',
              icon: Icons.medication_outlined,
              iconGradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.secondaryLight],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ilacCtrl,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: _inputDeco(
                            label: 'Ilac adi ekle',
                            hint: 'Orn: Metformin 1000mg',
                            icon: Icons.add_circle_outline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonLinearGradient,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_ilacCtrl.text.trim().isNotEmpty) {
                                provider.addIlac(_ilacCtrl.text);
                                _ilacCtrl.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusM),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                            ),
                            child: Text('Ekle',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (provider.kullanilanIlaclar.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...provider.kullanilanIlaclar
                        .asMap()
                        .entries
                        .map((e) {
                      final i = e.key;
                      final ilac = e.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS),
                          border:
                              Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                  Icons.medication_outlined,
                                  size: 14,
                                  color: AppColors.secondary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ilac,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.bodyText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => provider.removeIlac(i),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.errorLight,
                                  borderRadius:
                                      BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),

            // ── Alerji ──────────────────────────────────────────────
            SectionCard(
              title: 'Alerji Durumu',
              icon: Icons.warning_amber_outlined,
              iconGradient: const LinearGradient(
                colors: [AppColors.warning, Color(0xFFFBBF24)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alerji var mi?',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: AppColors.bodyText,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Ilac, gida veya diger alerjiler',
                              style: GoogleFonts.poppins(
                                color: AppColors.subtitle,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        key: const ValueKey('switch_alerji'),
                        value: provider.alerjisi,
                        onChanged: (v) {
                          provider.updateAlerjisi(v);
                          if (!v) _alerjiCtrl.clear();
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        key: const ValueKey('input_alerji_aciklama'),
                        controller: _alerjiCtrl,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        minLines: 2,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _inputDeco(
                          label: 'Alerji Aciklamasi *',
                          hint:
                              'Alerji nedenlerinizi ve reaksiyonlarinizi belirtin',
                          icon: Icons.edit_note_outlined,
                        ),
                        onChanged: provider.updateAlerjiAciklama,
                        validator: provider.alerjisi
                            ? Validators.validateAlerjiAciklama
                            : null,
                      ),
                    ),
                    crossFadeState: provider.alerjisi
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, size: 20, color: AppColors.subtitle)
          : null,
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide:
            const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
          color: AppColors.subtitle, fontSize: 14),
      hintStyle: GoogleFonts.poppins(
          color: AppColors.disabled, fontSize: 14),
      errorStyle: GoogleFonts.poppins(
          color: AppColors.error, fontSize: 12),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.child,
  });

  final String label;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}
