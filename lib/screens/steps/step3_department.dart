import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/doctor_model.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/section_card.dart';

class Step3Department extends StatelessWidget {
  const Step3Department({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    final hospitals =
        MockData.hospitalsByCity[provider.sehir] ?? <String>[];
    final departments =
        MockData.departmentsByHospital[provider.hastane] ?? <String>[];
    final doctors =
        (provider.hastane.isNotEmpty && provider.bolum.isNotEmpty)
            ? MockData.getDoctors(provider.hastane, provider.bolum)
            : <DoctorModel>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Secim cascading dropdowns ────────────────────────────
          SectionCard(
            title: 'Konum Secimi',
            icon: Icons.location_city_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DropdownRow(
                  label: 'Sehir *',
                  errorText: provider.sehirError,
                  child: DropdownButton<String>(
                    key: const ValueKey('dropdown_sehir'),
                    value:
                        provider.sehir.isEmpty ? null : provider.sehir,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    hint: Text('Sehir secin',
                        style: GoogleFonts.poppins(
                            color: AppColors.subtitle)),
                    icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary),
                    style: GoogleFonts.poppins(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: MockData.cities
                        .map((c) => DropdownMenuItem(
                            value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) provider.updateSehir(v);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _DropdownRow(
                  label: 'Hastane *',
                  errorText: provider.hastaneError,
                  child: DropdownButton<String>(
                    key: const ValueKey('dropdown_hastane'),
                    value: provider.hastane.isEmpty
                        ? null
                        : provider.hastane,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    hint: Text(
                      provider.sehir.isEmpty
                          ? 'Once sehir secin'
                          : 'Hastane secin',
                      style: GoogleFonts.poppins(
                          color: AppColors.subtitle),
                    ),
                    icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary),
                    style: GoogleFonts.poppins(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: hospitals
                        .map((h) => DropdownMenuItem(
                            value: h, child: Text(h)))
                        .toList(),
                    onChanged: hospitals.isEmpty
                        ? null
                        : (v) {
                            if (v != null) provider.updateHastane(v);
                          },
                  ),
                ),
              ],
            ),
          ),

          // ── Bolum ──────────────────────────────────────────────────
          SectionCard(
            title: 'Bolum Secimi',
            icon: Icons.account_tree_outlined,
            iconGradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentLight],
            ),
            child: _DropdownRow(
              label: 'Bolum *',
              errorText: provider.bolumError,
              child: DropdownButton<String>(
                key: const ValueKey('dropdown_bolum'),
                value:
                    provider.bolum.isEmpty ? null : provider.bolum,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                hint: Text(
                  provider.hastane.isEmpty
                      ? 'Once hastane secin'
                      : 'Bolum secin',
                  style:
                      GoogleFonts.poppins(color: AppColors.subtitle),
                ),
                icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary),
                style: GoogleFonts.poppins(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: departments
                    .map((d) => DropdownMenuItem(
                        value: d, child: Text(d)))
                    .toList(),
                onChanged: departments.isEmpty
                    ? null
                    : (v) {
                        if (v != null) provider.updateBolum(v);
                      },
              ),
            ),
          ),

          // ── Doktor Dropdown ──────────────────────────────────────
          if (doctors.isNotEmpty)
            SectionCard(
              title: 'Doktor Secimi (Hizli)',
              icon: Icons.medical_services_outlined,
              iconGradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.secondaryLight],
              ),
              child: _DropdownRow(
                label: 'Doktor *',
                errorText: provider.doktorError,
                child: DropdownButton<String>(
                  key: const ValueKey('dropdown_doktor'),
                  value: provider.doktorId.isEmpty
                      ? null
                      : provider.doktorId,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  hint: Text('Doktor secin',
                      style: GoogleFonts.poppins(
                          color: AppColors.subtitle)),
                  icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary),
                  style: GoogleFonts.poppins(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  items: doctors
                      .map((d) => DropdownMenuItem(
                            value: d.id,
                            child: Text(d.fullName,
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (id) {
                    if (id != null) {
                      final doctor =
                          doctors.firstWhere((d) => d.id == id);
                      provider.updateDoktor(doctor);
                    }
                  },
                ),
              ),
            ),

          // ── Doktor listesi ──────────────────────────────────────
          if (doctors.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryUltraLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.list_alt_outlined,
                        size: 14, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Doktorlar (${doctors.length})',
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ...doctors.asMap().entries.map((e) {
              final index = e.key;
              final doctor = e.value;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: DoctorCard(
                  doctor: doctor,
                  isSelected: provider.doktorId == doctor.id,
                  onTap: () => provider.updateDoktor(doctor),
                  index: index,
                ),
              );
            }),
          ],

          if (doctors.isEmpty && provider.bolum.isNotEmpty)
            SectionCard(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.search_off_rounded,
                            size: 36,
                            color: AppColors.subtitle
                                .withOpacity(0.5)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bu bolumde doktor bulunamadi',
                        style: GoogleFonts.poppins(
                          color: AppColors.subtitle,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (provider.doktorError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusS),
                  border: Border.all(
                      color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      provider.doktorError!,
                      style: GoogleFonts.poppins(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.child,
    this.errorText,
  });

  final String label;
  final Widget child;
  final String? errorText;

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
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.border,
              width: errorText != null ? 1.5 : 1,
            ),
          ),
          child: child,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorText!,
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
