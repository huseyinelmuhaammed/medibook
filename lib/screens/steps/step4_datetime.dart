import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/section_card.dart';
import '../../widgets/slot_grid.dart';

class Step4DateTime extends StatefulWidget {
  const Step4DateTime({super.key});

  @override
  State<Step4DateTime> createState() => _Step4DateTimeState();
}

class _Step4DateTimeState extends State<Step4DateTime> {
  late TextEditingController _notlarCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppointmentProvider>();
    _notlarCtrl = TextEditingController(text: p.notlar);
  }

  @override
  void dispose() {
    _notlarCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(AppointmentProvider provider) async {
    final now = DateTime.now();
    final initial =
        provider.selectedDate ?? now.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: _findNextWorkday(initial),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 90)),
      locale: const Locale('tr', 'TR'),
      helpText: 'Randevu Tarihi Secin',
      selectableDayPredicate: (day) {
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          return false;
        }
        if (MockData.isHoliday(day)) return false;
        return true;
      },
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      provider.updateSelectedDate(picked);
    }
  }

  DateTime _findNextWorkday(DateTime date) {
    var d = date;
    while (d.weekday == DateTime.saturday ||
        d.weekday == DateTime.sunday ||
        MockData.isHoliday(d)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: provider.step4FormKey,
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Acil randevu ─────────────────────────────────────────
            if (provider.acilRandevu) _buildAcilBanner(context),

            // ── Tarih secimi ─────────────────────────────────────────
            SectionCard(
              title: 'Randevu Tarihi',
              icon: Icons.calendar_month_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: provider.selectedDate != null
                            ? AppColors.buttonLinearGradient
                            : null,
                        color: provider.selectedDate != null
                            ? null
                            : AppColors.inputFill,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM),
                        border: Border.all(
                          color: provider.tarihError != null
                              ? AppColors.error
                              : provider.selectedDate != null
                                  ? Colors.transparent
                                  : AppColors.border,
                        ),
                        boxShadow: provider.selectedDate != null
                            ? AppShadows.primaryGlow
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          key: const ValueKey('btn_tarih_sec'),
                          onTap: () => _selectDate(provider),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  color: provider.selectedDate != null
                                      ? Colors.white
                                      : AppColors.bodyText,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  provider.selectedDate == null
                                      ? 'Tarih Seçin'
                                      : DateFormat('dd MMMM yyyy', 'tr_TR')
                                          .format(provider.selectedDate!),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: provider.selectedDate != null
                                        ? Colors.white
                                        : AppColors.bodyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (provider.tarihError != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 6, left: 4),
                      child: Text(
                        provider.tarihError!,
                        style: GoogleFonts.poppins(
                            color: AppColors.error, fontSize: 12),
                      ),
                    ),
                  if (provider.selectedDate != null) ...[
                    const SizedBox(height: 10),
                    _buildDateInfoChip(provider.selectedDate!),
                  ],
                ],
              ),
            ),

            // ── Saat secimi ──────────────────────────────────────────
            if (provider.selectedDate != null)
              SectionCard(
                title: 'Saat Secimi',
                icon: Icons.schedule_outlined,
                iconGradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentLight],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildLegendChip(
                          color: AppColors.success,
                          bgColor: AppColors.successLight,
                          label: 'Bos',
                        ),
                        const SizedBox(width: 8),
                        _buildLegendChip(
                          color: AppColors.disabled,
                          bgColor: AppColors.disabledBg,
                          label: 'Dolu',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SlotGrid(
                      selectedDate: provider.selectedDate!,
                      selectedSaat: provider.selectedSaat,
                      onSlotTap: provider.updateSelectedSaat,
                    ),
                    if (provider.saatError != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          provider.saatError!,
                          style: GoogleFonts.poppins(
                              color: AppColors.error,
                              fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

            // ── Acil randevu switch ──────────────────────────────────
            SectionCard(
              title: 'Acil Randevu',
              icon: Icons.emergency_outlined,
              iconGradient: const LinearGradient(
                colors: [AppColors.error, Color(0xFFF87171)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acil randevu talebi',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.bodyText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.acilRandevu
                              ? 'Talebiniz oncelikli olarak degerlendirilecek'
                              : 'Acil durumlar icin randevu onceligi talep edin',
                          style: GoogleFonts.poppins(
                            color: provider.acilRandevu
                                ? AppColors.acilColor
                                : AppColors.subtitle,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    key: const ValueKey('switch_acil'),
                    value: provider.acilRandevu,
                    onChanged: provider.updateAcilRandevu,
                    activeColor: AppColors.acilColor,
                  ),
                ],
              ),
            ),

            // ── Notlar ───────────────────────────────────────────────
            SectionCard(
              title: 'Notlar & Aciklama',
              icon: Icons.note_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const ValueKey('input_notlar'),
                    controller: _notlarCtrl,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 4,
                    minLines: 3,
                    maxLength: 200,
                    style: GoogleFonts.poppins(fontSize: 14),
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) {
                      final remaining =
                          (maxLength ?? 200) - currentLength;
                      return Text(
                        '$remaining karakter kaldi',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: remaining < 20
                              ? AppColors.warning
                              : AppColors.subtitle,
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Doktora iletmek istediginiz bilgileri yazin...',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM),
                        borderSide: const BorderSide(
                            color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM),
                        borderSide: const BorderSide(
                            color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.disabled, fontSize: 14),
                    ),
                    onChanged: (v) {
                      provider.updateNotlar(v);
                    },
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

  Widget _buildLegendChip({
    required Color color,
    required Color bgColor,
    required String label,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDateInfoChip(DateTime date) {
    final weekdays = [
      'Pazartesi', 'Sali', 'Carsamba', 'Persembe',
      'Cuma', 'Cumartesi', 'Pazar',
    ];
    final weekday = weekdays[date.weekday - 1];
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryUltraLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_available_outlined,
              size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$weekday, ${DateFormat('dd MMMM yyyy', 'tr_TR').format(date)}',
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcilBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.acilBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
            color: AppColors.acilColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.acilColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.priority_high,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acil Randevu Modu Aktif',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppColors.acilColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Randevunuz oncelikli olarak degerlendirilecektir.',
                  style: GoogleFonts.poppins(
                    color: AppColors.acilColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
