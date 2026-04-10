import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/doctor_card.dart';

class Step3Department extends StatelessWidget {
  const Step3Department({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appt = provider.currentAppointment;

    final sehirler = MockData.sehirHastaneler.keys.toList()..sort();
    final hastaneler = appt.sehir.isNotEmpty
        ? (MockData.sehirHastaneler[appt.sehir] ?? [])
        : <String>[];
    final bolumler = appt.hastane.isNotEmpty
        ? (MockData.hastaneBolumler[appt.hastane] ?? [])
        : <String>[];
    final doktorlar = (appt.hastane.isNotEmpty && appt.bolum.isNotEmpty)
        ? MockData.getDoktorlar(appt.hastane, appt.bolum)
        : [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            key: const ValueKey('dropdown_sehir'),
            value: appt.sehir.isEmpty ? null : appt.sehir,
            decoration: const InputDecoration(
              labelText: 'Şehir *',
              prefixIcon: Icon(Icons.location_city),
            ),
            items: sehirler.map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                context.read<AppointmentProvider>().updateField('sehir', v);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: const ValueKey('dropdown_hastane'),
            value: (appt.hastane.isNotEmpty && hastaneler.contains(appt.hastane))
                ? appt.hastane
                : null,
            decoration: const InputDecoration(
              labelText: 'Hastane *',
              prefixIcon: Icon(Icons.local_hospital),
            ),
            items: hastaneler.map((h) {
              return DropdownMenuItem(value: h, child: Text(h));
            }).toList(),
            onChanged: appt.sehir.isEmpty
                ? null
                : (v) {
                    if (v != null) {
                      context.read<AppointmentProvider>().updateField('hastane', v);
                    }
                  },
            hint: appt.sehir.isEmpty ? const Text('Önce şehir seçin') : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: const ValueKey('dropdown_bolum'),
            value: (appt.bolum.isNotEmpty && bolumler.contains(appt.bolum))
                ? appt.bolum
                : null,
            decoration: const InputDecoration(
              labelText: 'Bölüm *',
              prefixIcon: Icon(Icons.medical_services),
            ),
            items: bolumler.map((b) {
              return DropdownMenuItem(value: b, child: Text(b));
            }).toList(),
            onChanged: appt.hastane.isEmpty
                ? null
                : (v) {
                    if (v != null) {
                      context.read<AppointmentProvider>().updateField('bolum', v);
                    }
                  },
            hint: appt.hastane.isEmpty ? const Text('Önce hastane seçin') : null,
          ),
          const SizedBox(height: 16),
          if (appt.bolum.isNotEmpty && doktorlar.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              key: const ValueKey('dropdown_doktor'),
              value: (appt.doktorId.isNotEmpty &&
                      doktorlar.any((d) => d.id == appt.doktorId))
                  ? appt.doktorId
                  : null,
              decoration: const InputDecoration(
                labelText: 'Doktor *',
                prefixIcon: Icon(Icons.person_pin),
              ),
              items: doktorlar.map((d) {
                return DropdownMenuItem(value: d.id, child: Text(d.ad));
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  final doc = doktorlar.firstWhere((d) => d.id == v);
                  context.read<AppointmentProvider>().updateField('doktorId', v);
                  context.read<AppointmentProvider>().updateField('doktorAdi', doc.ad);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Doktor Listesi',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            ...doktorlar.asMap().entries.map((entry) {
              final index = entry.key;
              final doctor = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DoctorCard(
                  key: ValueKey('doktor_item_$index'),
                  doctor: doctor,
                  isSelected: appt.doktorId == doctor.id,
                  onTap: () {
                    context.read<AppointmentProvider>().updateField('doktorId', doctor.id);
                    context.read<AppointmentProvider>().updateField('doktorAdi', doctor.ad);
                  },
                ),
              );
            }),
          ] else if (appt.bolum.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              key: const ValueKey('dropdown_doktor'),
              value: null,
              decoration: const InputDecoration(
                labelText: 'Doktor *',
                prefixIcon: Icon(Icons.person_pin),
              ),
              items: const [],
              onChanged: null,
              hint: const Text('Bu bölümde doktor bulunamadı'),
            ),
          ] else ...[
            DropdownButtonFormField<String>(
              key: const ValueKey('dropdown_doktor'),
              value: null,
              decoration: const InputDecoration(
                labelText: 'Doktor *',
                prefixIcon: Icon(Icons.person_pin),
              ),
              items: const [],
              onChanged: null,
              hint: const Text('Önce bölüm seçin'),
            ),
          ],
        ],
      ),
    );
  }
}
