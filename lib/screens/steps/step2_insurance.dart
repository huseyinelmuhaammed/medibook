import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/constants.dart';

class Step2Insurance extends StatefulWidget {
  const Step2Insurance({super.key});

  @override
  State<Step2Insurance> createState() => Step2InsuranceState();
}

class Step2InsuranceState extends State<Step2Insurance> {
  final _formKey = GlobalKey<FormState>();
  final _firmaController = TextEditingController();
  final _alerjiController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final appt = context.read<AppointmentProvider>().currentAppointment;
      _firmaController.text = appt.sigortaFirma;
      _alerjiController.text = appt.alerjiAciklama;
    }
  }

  @override
  void dispose() {
    _firmaController.dispose();
    _alerjiController.dispose();
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appt = provider.currentAppointment;
    final showFirma = appt.sigortaTuru == 'SGK' || appt.sigortaTuru == 'Özel';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sigorta Bilgileri',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const ValueKey('dropdown_sigorta'),
              value: appt.sigortaTuru.isEmpty ? null : appt.sigortaTuru,
              decoration: const InputDecoration(
                labelText: 'Sigorta Türü',
                prefixIcon: Icon(Icons.health_and_safety),
              ),
              items: AppConstants.sigortaTurleri.map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  context.read<AppointmentProvider>().updateField('sigortaTuru', v);
                  if (v == 'Yok') {
                    _firmaController.clear();
                    context.read<AppointmentProvider>().updateField('sigortaFirma', '');
                  }
                }
              },
            ),
            if (showFirma) ...[
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('input_sigorta_firma'),
                controller: _firmaController,
                decoration: InputDecoration(
                  labelText: appt.sigortaTuru == 'SGK' ? 'SGK Sicil No' : 'Sigorta Firması',
                  prefixIcon: const Icon(Icons.business),
                ),
                onChanged: (v) =>
                    context.read<AppointmentProvider>().updateField('sigortaFirma', v),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Sağlık Bilgileri',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              key: const ValueKey('switch_alerji'),
              title: const Text('Alerjim var'),
              subtitle: const Text('İlaç, besin veya diğer alerjiler'),
              value: appt.alerjisi,
              onChanged: (v) {
                context.read<AppointmentProvider>().updateField('alerjisi', v);
                if (!v) {
                  _alerjiController.clear();
                  context.read<AppointmentProvider>().updateField('alerjiAciklama', '');
                }
              },
              secondary: const Icon(Icons.warning_amber),
            ),
            if (appt.alerjisi) ...[
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('input_alerji_aciklama'),
                controller: _alerjiController,
                decoration: const InputDecoration(
                  labelText: 'Alerji Açıklaması',
                  prefixIcon: Icon(Icons.info),
                  hintText: 'Alerjilerinizi açıklayın...',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (v) {
                  if (appt.alerjisi && (v == null || v.trim().isEmpty)) {
                    return 'Lütfen alerjilerinizi açıklayın';
                  }
                  return null;
                },
                onChanged: (v) =>
                    context.read<AppointmentProvider>().updateField('alerjiAciklama', v),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
