import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../widgets/section_card.dart';
import '../../utils/formatters.dart';

class Step6Summary extends StatelessWidget {
  const Step6Summary({super.key});

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appt = context.watch<AppointmentProvider>().currentAppointment;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lütfen bilgilerinizi gözden geçirin ve onaylayın.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Kişisel Bilgiler',
            icon: Icons.person,
            children: [
              _row(context, 'Ad Soyad', '${appt.ad} ${appt.soyad}'),
              _row(context, 'TC Kimlik No', appt.tc),
              _row(context, 'E-posta', appt.email),
              _row(context, 'Telefon', appt.telefon),
              _row(context, 'Doğum Tarihi', appt.dogumTarihi),
              _row(context, 'Cinsiyet', appt.cinsiyet == 'erkek' ? 'Erkek' : 'Kadın'),
              _row(context, 'Adres', appt.adres),
            ],
          ),
          SectionCard(
            title: 'Sigorta & Sağlık',
            icon: Icons.health_and_safety,
            children: [
              _row(context, 'Sigorta Türü', appt.sigortaTuru.isEmpty ? '-' : appt.sigortaTuru),
              if (appt.sigortaFirma.isNotEmpty)
                _row(context, 'Sigorta Firma', appt.sigortaFirma),
              _row(context, 'Alerjisi', appt.alerjisi ? 'Var' : 'Yok'),
              if (appt.alerjisi && appt.alerjiAciklama.isNotEmpty)
                _row(context, 'Alerji Açıklama', appt.alerjiAciklama),
            ],
          ),
          SectionCard(
            title: 'Bölüm & Doktor',
            icon: Icons.local_hospital,
            children: [
              _row(context, 'Şehir', appt.sehir),
              _row(context, 'Hastane', appt.hastane),
              _row(context, 'Bölüm', appt.bolum),
              _row(context, 'Doktor', appt.doktorAdi),
            ],
          ),
          SectionCard(
            title: 'Tarih & Saat',
            icon: Icons.schedule,
            children: [
              _row(
                context,
                'Randevu Tarihi',
                appt.randevuTarihi != null
                    ? Formatters.formatTarih(appt.randevuTarihi!)
                    : '-',
              ),
              _row(context, 'Randevu Saati', appt.randevuSaati ?? '-'),
              _row(context, 'Acil Durum', appt.acilDurum ? 'Evet' : 'Hayır'),
              if (appt.notlar.isNotEmpty) _row(context, 'Notlar', appt.notlar),
            ],
          ),
          SectionCard(
            title: 'Ek Hizmetler',
            icon: Icons.medical_services,
            children: [
              _row(
                context,
                'Seçilen Hizmetler',
                appt.ekHizmetler.isEmpty ? 'Yok' : appt.ekHizmetler.join(', '),
              ),
              _row(context, 'Refakatçi Sayısı', '${appt.refakatciSayisi} kişi'),
            ],
          ),
          SectionCard(
            title: 'Onaylar',
            icon: Icons.check_circle,
            children: [
              _row(context, 'KVKK Onayı', appt.kvkkOnay ? '✓ Kabul edildi' : '✗ Kabul edilmedi'),
              _row(context, 'Açık Rıza', appt.acikRizaOnay ? '✓ Kabul edildi' : '✗ Kabul edilmedi'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
