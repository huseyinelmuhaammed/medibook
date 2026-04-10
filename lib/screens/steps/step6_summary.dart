import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/section_card.dart';

class Step6Summary extends StatelessWidget {
  const Step6Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Randevu ozeti banner ─────────────────────────────────
          _buildSummaryBanner(context, provider),

          // ── Adim 1: Kisisel Bilgiler ─────────────────────────────
          _SummarySection(
            title: 'Kisisel Bilgiler',
            icon: Icons.person_outline_rounded,
            stepIndex: 0,
            children: [
              _SummaryRow(
                  label: 'Ad Soyad',
                  value: '${provider.ad} ${provider.soyad}'),
              _SummaryRow(label: 'TC Kimlik No', value: provider.tc),
              _SummaryRow(
                  label: 'Dogum Tarihi',
                  value: provider.dogumTarihi),
              _SummaryRow(
                  label: 'Cinsiyet', value: provider.cinsiyet),
              _SummaryRow(label: 'Telefon', value: provider.telefon),
              _SummaryRow(label: 'E-posta', value: provider.email),
              _SummaryRow(
                  label: 'Adres',
                  value: provider.adres,
                  isLong: true),
            ],
          ),

          // ── Adim 2: Sigorta & Saglik ─────────────────────────────
          _SummarySection(
            title: 'Sigorta & Saglik',
            icon: Icons.health_and_safety_outlined,
            stepIndex: 1,
            children: [
              _SummaryRow(
                label: 'Sigorta Turu',
                value: provider.sigortaTuru.isEmpty
                    ? 'Belirtilmedi'
                    : provider.sigortaTuru,
              ),
              if (provider.sigortaTuru == 'Özel Sigorta')
                _SummaryRow(
                    label: 'Sigorta Firmasi',
                    value: provider.sigortaFirma),
              _SummaryRow(
                label: 'Kronik Hastaliklar',
                value: provider.kronikHastaliklar.isEmpty
                    ? 'Yok'
                    : provider.kronikHastaliklar.join(', '),
              ),
              _SummaryRow(
                label: 'Kullanilan Ilaclar',
                value: provider.kullanilanIlaclar.isEmpty
                    ? 'Yok'
                    : provider.kullanilanIlaclar.join(', '),
              ),
              _SummaryRow(
                  label: 'Alerji',
                  value: provider.alerjisi ? 'Var' : 'Yok'),
              if (provider.alerjisi)
                _SummaryRow(
                    label: 'Alerji Aciklamasi',
                    value: provider.alerjiAciklama,
                    isLong: true),
            ],
          ),

          // ── Adim 3: Bolum & Doktor ───────────────────────────────
          _SummarySection(
            title: 'Bolum & Doktor',
            icon: Icons.medical_services_outlined,
            stepIndex: 2,
            children: [
              _SummaryRow(label: 'Sehir', value: provider.sehir),
              _SummaryRow(label: 'Hastane', value: provider.hastane),
              _SummaryRow(label: 'Bolum', value: provider.bolum),
              _SummaryRow(
                label: 'Doktor',
                value: provider.selectedDoctor?.fullName ??
                    provider.doktorId,
              ),
              if (provider.selectedDoctor != null)
                _SummaryRow(
                  label: 'Uzmanlik',
                  value: provider.selectedDoctor!.uzmanlik,
                ),
            ],
          ),

          // ── Adim 4: Tarih & Saat ─────────────────────────────────
          _SummarySection(
            title: 'Tarih & Saat',
            icon: Icons.schedule_outlined,
            stepIndex: 3,
            children: [
              _SummaryRow(
                label: 'Randevu Tarihi',
                value: provider.selectedDate != null
                    ? DateFormat('dd MMMM yyyy', 'tr_TR')
                        .format(provider.selectedDate!)
                    : '',
              ),
              _SummaryRow(
                  label: 'Randevu Saati',
                  value: provider.selectedSaat),
              _SummaryRow(
                label: 'Acil Randevu',
                value: provider.acilRandevu ? 'Evet' : 'Hayir',
                highlight: provider.acilRandevu,
              ),
              if (provider.notlar.isNotEmpty)
                _SummaryRow(
                    label: 'Notlar',
                    value: provider.notlar,
                    isLong: true),
            ],
          ),

          // ── Adim 5: Ek Hizmetler ────────────────────────────────
          _SummarySection(
            title: 'Ek Hizmetler',
            icon: Icons.add_circle_outline_rounded,
            stepIndex: 4,
            children: [
              _SummaryRow(
                label: 'Kan Tahlili',
                value: provider.kanTahlili ? 'Evet' : 'Hayir',
              ),
              _SummaryRow(
                  label: 'MR',
                  value: provider.mr ? 'Evet' : 'Hayir'),
              _SummaryRow(
                label: 'Rontgen',
                value: provider.rontgen ? 'Evet' : 'Hayir',
              ),
              _SummaryRow(
                label: 'Refakatci',
                value: '${provider.refakatciSayisi} kisi',
              ),
              if (provider.ulasimYardimi.isNotEmpty)
                _SummaryRow(
                    label: 'Ulasim',
                    value: provider.ulasimYardimi),
            ],
          ),

          // ── Toplam Ucret ─────────────────────────────────────────
          _buildTotalCard(context, provider),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner(
      BuildContext context, AppointmentProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1D4ED8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Randevu Ozeti',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.selectedDate != null &&
                          provider.selectedSaat.isNotEmpty
                      ? '${DateFormat('dd MMM yyyy', 'tr_TR').format(provider.selectedDate!)}, ${provider.selectedSaat}'
                      : 'Lutfen tum adimlari tamamlayin',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
                if (provider.hastane.isNotEmpty)
                  Text(
                    '${provider.hastane} · ${provider.bolum}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(
      BuildContext context, AppointmentProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryUltraLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.15)),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toplam Tutar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                AppFormatters.formatCurrency(provider.toplamFiyat),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    size: 12, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'SGK katki payi dusuldukten sonra odenecek tutar degisebilir.',
                  style: GoogleFonts.poppins(
                    color: AppColors.subtitle,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.title,
    required this.icon,
    required this.stepIndex,
    required this.children,
  });

  final String title;
  final IconData icon;
  final int stepIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: icon,
      trailing: TextButton.icon(
        onPressed: () {
          context.read<AppointmentProvider>().goToStep(stepIndex);
        },
        icon: const Icon(Icons.edit_outlined, size: 14),
        label: Text('Duzenle',
            style: GoogleFonts.poppins(fontSize: 12)),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding:
              const EdgeInsets.symmetric(horizontal: 8),
          visualDensity: VisualDensity.compact,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLong = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool isLong;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: isLong
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppColors.subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: AppColors.bodyText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Divider(
                    height: 1, color: AppColors.divider),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitle,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: highlight
                          ? AppColors.acilColor
                          : AppColors.bodyText,
                      fontSize: 13,
                      fontWeight: highlight
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
    );
  }
}
