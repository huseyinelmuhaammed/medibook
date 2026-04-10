import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/section_card.dart';

class Step5Services extends StatelessWidget {
  const Step5Services({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Ek Tetkikler ─────────────────────────────────────────
          SectionCard(
            title: 'Ek Tetkikler',
            icon: Icons.biotech_outlined,
            iconGradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentLight],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Randevunuzla birlikte yapilmasini istediginiz tetkikleri secin',
                  style: GoogleFonts.poppins(
                    color: AppColors.subtitle,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ServiceChip(
                      chipKey: const ValueKey('chip_kan_tahlili'),
                      label: 'Kan Tahlili',
                      icon: Icons.water_drop_outlined,
                      price: MockData.kanTahlilifiyati,
                      selected: provider.kanTahlili,
                      onSelected: provider.updateKanTahlili,
                    ),
                    _ServiceChip(
                      chipKey: const ValueKey('chip_mr'),
                      label: 'MR',
                      icon: Icons.document_scanner_outlined,
                      price: MockData.mrFiyati,
                      selected: provider.mr,
                      onSelected: provider.updateMr,
                    ),
                    _ServiceChip(
                      chipKey: const ValueKey('chip_rontgen'),
                      label: 'Rontgen',
                      icon: Icons.healing_outlined,
                      price: MockData.rontgenFiyati,
                      selected: provider.rontgen,
                      onSelected: provider.updateRontgen,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Refakatci ────────────────────────────────────────────
          SectionCard(
            title: 'Refakatci',
            icon: Icons.group_outlined,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Refakatci Sayisi',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodyText,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Yaninizda gelecek kisi sayisi (max. 3)',
                        style: GoogleFonts.poppins(
                          color: AppColors.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stepper
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      _buildStepperButton(
                        icon: Icons.remove_rounded,
                        enabled: provider.refakatciSayisi > 0,
                        onTap: provider.refakatciSayisi > 0
                            ? provider.decrementRefakatci
                            : null,
                        key: const ValueKey(
                            'stepper_refakatci_minus'),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS),
                        ),
                        child: Center(
                          child: Text(
                            '${provider.refakatciSayisi}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      _buildStepperButton(
                        icon: Icons.add_rounded,
                        enabled: provider.refakatciSayisi < 3,
                        onTap: provider.refakatciSayisi < 3
                            ? provider.incrementRefakatci
                            : null,
                        key: const ValueKey(
                            'stepper_refakatci_plus'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Ulasim Yardimi ───────────────────────────────────────
          SectionCard(
            title: 'Ulasim Yardimi',
            icon: Icons.directions_car_outlined,
            iconGradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.secondaryLight],
            ),
            child: Column(
              children: MockData.ulasimSecenekleri.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  value: option,
                  groupValue: provider.ulasimYardimi.isEmpty
                      ? null
                      : provider.ulasimYardimi,
                  onChanged: (v) {
                    if (v != null) provider.updateUlasimYardimi(v);
                  },
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }).toList(),
            ),
          ),

          // ── Hatirlatmalar ────────────────────────────────────────
          SectionCard(
            title: 'Hatirlatma Tercihleri',
            icon: Icons.notifications_none_outlined,
            child: Column(
              children:
                  MockData.hatirlatmaSecenekleri.map((option) {
                final selected =
                    provider.hatirlatmalar.contains(option);
                return CheckboxListTile(
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  value: selected,
                  onChanged: (_) =>
                      provider.toggleHatirlatma(option),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),

          // ── Fiyat ozeti ──────────────────────────────────────────
          _buildPriceSummary(context, provider),

          // ── Yasal Onaylar ────────────────────────────────────────
          SectionCard(
            title: 'Yasal Onaylar',
            icon: Icons.gavel_outlined,
            iconGradient: const LinearGradient(
              colors: [AppColors.warning, Color(0xFFFBBF24)],
            ),
            color: const Color(0xFFFFFBEB),
            child: Column(
              children: [
                _buildLegalCheckbox(
                  key: const ValueKey('checkbox_kvkk'),
                  title: 'KVKK Aydinlatma Metni',
                  subtitle:
                      'Kisisel verilerimin islenmesine iliskin aydinlatma metnini okudum ve onayliyorum.',
                  value: provider.kvkkKabul,
                  onChanged: (v) =>
                      provider.updateKvkkKabul(v ?? false),
                  linkText: 'KVKK Metnini Goruntule',
                ),
                const Divider(
                    height: 20, color: AppColors.divider),
                _buildLegalCheckbox(
                  key: const ValueKey('checkbox_acik_riza'),
                  title: 'Acik Riza Beyani',
                  subtitle:
                      'Saglik verilerimin toplanmasi ve islenmesi icin acik riza veriyorum.',
                  value: provider.acikRizaKabul,
                  onChanged: (v) =>
                      provider.updateAcikRizaKabul(v ?? false),
                  linkText: 'Acik Riza Metnini Goruntule',
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback? onTap,
    required Key key,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primary : AppColors.disabled,
        ),
      ),
    );
  }

  Widget _buildPriceSummary(
      BuildContext context, AppointmentProvider provider) {
    return SectionCard(
      title: 'Tahmini Ucret',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          _PriceRow(
              label: 'Muayene Bedeli',
              amount: MockData.muayeneBedeli),
          if (provider.kanTahlili)
            _PriceRow(
                label: 'Kan Tahlili',
                amount: MockData.kanTahlilifiyati),
          if (provider.mr)
            _PriceRow(
                label: 'MR Cekimi', amount: MockData.mrFiyati),
          if (provider.rontgen)
            _PriceRow(
                label: 'Rontgen', amount: MockData.rontgenFiyati),
          if (provider.refakatciSayisi > 0)
            _PriceRow(
              label:
                  'Refakatci (${provider.refakatciSayisi} kisi)',
              amount: provider.refakatciSayisi *
                  MockData.refakatciFiyati,
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryUltraLight,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Toplam',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  AppFormatters.formatCurrency(provider.toplamFiyat),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCheckbox({
    required Key key,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String linkText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          key: key,
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.bodyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.subtitle,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  linkText,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.chipKey,
    required this.label,
    required this.icon,
    required this.price,
    required this.selected,
    required this.onSelected,
  });

  final Key chipKey;
  final String label;
  final IconData icon;
  final double price;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryUltraLight
              : AppColors.inputFill,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color:
                selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected
                    ? AppColors.primary
                    : AppColors.subtitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              AppFormatters.formatCurrency(price),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: selected
                    ? AppColors.primary
                    : AppColors.subtitle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.bodyText,
            ),
          ),
          Text(
            AppFormatters.formatCurrency(amount),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.bodyText,
            ),
          ),
        ],
      ),
    );
  }
}
