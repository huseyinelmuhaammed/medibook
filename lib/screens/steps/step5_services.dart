import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';

class Step5Services extends StatefulWidget {
  const Step5Services({super.key});

  @override
  State<Step5Services> createState() => Step5ServicesState();
}

class Step5ServicesState extends State<Step5Services> {
  bool validate() {
    final appt = context.read<AppointmentProvider>().currentAppointment;
    if (!appt.kvkkOnay) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('KVKK metnini kabul etmeniz gerekmektedir'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (!appt.acikRizaOnay) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Açık Rıza metnini kabul etmeniz gerekmektedir'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  void _toggleEkHizmet(AppointmentProvider provider, String hizmet) {
    final current = List<String>.from(provider.currentAppointment.ekHizmetler);
    if (current.contains(hizmet)) {
      current.remove(hizmet);
    } else {
      current.add(hizmet);
    }
    provider.updateField('ekHizmetler', current);
  }

  static const Map<String, String> _chipKeys = {
    'Kan Tahlili': 'chip_kan_tahlili',
    'MR': 'chip_mr',
    'Röntgen': 'chip_rontgen',
    'EKG': 'chip_ekg',
    'Ultrason': 'chip_ultrason',
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appt = provider.currentAppointment;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ek Hizmetler',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'İhtiyacınız olan ek hizmetleri seçebilirsiniz',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.ekHizmetlerListesi.map((hizmet) {
              final isSelected = appt.ekHizmetler.contains(hizmet);
              return FilterChip(
                key: ValueKey(_chipKeys[hizmet] ?? hizmet),
                label: Text(hizmet),
                selected: isSelected,
                onSelected: (_) => _toggleEkHizmet(provider, hizmet),
                avatar: isSelected
                    ? Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.primary)
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Refakatçi Sayısı',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                key: const ValueKey('stepper_refakatci_minus'),
                onPressed: appt.refakatciSayisi > 0
                    ? () => provider.updateField('refakatciSayisi', appt.refakatciSayisi - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${appt.refakatciSayisi}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton.outlined(
                key: const ValueKey('stepper_refakatci_plus'),
                onPressed: appt.refakatciSayisi < 5
                    ? () => provider.updateField('refakatciSayisi', appt.refakatciSayisi + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Onaylar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            key: const ValueKey('checkbox_kvkk'),
            title: const Text('KVKK Aydınlatma Metnini okudum ve kabul ediyorum'),
            subtitle: const Text('Kişisel verilerinizin korunması hakkında bilgilendirme'),
            value: appt.kvkkOnay,
            onChanged: (v) => provider.updateField('kvkkOnay', v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            isThreeLine: true,
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            key: const ValueKey('checkbox_acik_riza'),
            title: const Text('Açık Rıza Beyanını okudum ve kabul ediyorum'),
            subtitle: const Text('Sağlık verilerinizin işlenmesine onay veriyorsunuz'),
            value: appt.acikRizaOnay,
            onChanged: (v) => provider.updateField('acikRizaOnay', v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
