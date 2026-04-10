import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/slot_grid.dart';
import '../../utils/formatters.dart';

class Step4DateTime extends StatefulWidget {
  const Step4DateTime({super.key});

  @override
  State<Step4DateTime> createState() => Step4DateTimeState();
}

class Step4DateTimeState extends State<Step4DateTime> {
  final _notlarController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final appt = context.read<AppointmentProvider>().currentAppointment;
      _notlarController.text = appt.notlar;
    }
  }

  @override
  void dispose() {
    _notlarController.dispose();
    super.dispose();
  }

  bool validate() {
    final appt = context.read<AppointmentProvider>().currentAppointment;
    if (appt.randevuTarihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen randevu tarihi seçin'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (appt.randevuSaati == null || appt.randevuSaati!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen randevu saati seçin'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 90));

    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('tr'),
      selectableDayPredicate: (day) {
        return day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;
      },
    );

    if (picked != null && mounted) {
      context.read<AppointmentProvider>().updateField('randevuTarihi', picked);
      context.read<AppointmentProvider>().updateField('randevuSaati', null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appt = provider.currentAppointment;
    final doluSlotlar = appt.randevuTarihi != null
        ? MockData.getDoluSlotlar(appt.randevuTarihi!)
        : <String>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Randevu Tarihi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            key: const ValueKey('btn_tarih_sec'),
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today),
            label: Text(
              appt.randevuTarihi != null
                  ? Formatters.formatTarih(appt.randevuTarihi!)
                  : 'Tarih Seçin',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
          if (appt.randevuTarihi != null) ...[
            const SizedBox(height: 24),
            Text(
              'Uygun Saatler',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kırmızı: Dolu · Yeşil: Seçili',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 12),
            SlotGrid(
              selectedSlot: appt.randevuSaati,
              doluSlotlar: doluSlotlar,
              onSlotSelected: (slot) {
                context.read<AppointmentProvider>().updateField('randevuSaati', slot);
              },
            ),
          ],
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          SwitchListTile(
            key: const ValueKey('switch_acil'),
            title: const Text('Acil Durum'),
            subtitle: const Text('Bu randevu acil bir durum için mi?'),
            value: appt.acilDurum,
            onChanged: (v) =>
                context.read<AppointmentProvider>().updateField('acilDurum', v),
            secondary: Icon(
              Icons.emergency,
              color: appt.acilDurum ? Colors.red : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('input_notlar'),
            controller: _notlarController,
            decoration: const InputDecoration(
              labelText: 'Notlar',
              prefixIcon: Icon(Icons.notes),
              hintText: 'Doktora iletmek istediğiniz notları yazın...',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged: (v) => context.read<AppointmentProvider>().updateField('notlar', v),
          ),
        ],
      ),
    );
  }
}
