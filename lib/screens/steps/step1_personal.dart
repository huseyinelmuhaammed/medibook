import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/validators.dart';
import '../../utils/formatters.dart';

class Step1Personal extends StatefulWidget {
  const Step1Personal({super.key});

  @override
  State<Step1Personal> createState() => Step1PersonalState();
}

class Step1PersonalState extends State<Step1Personal> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _tcController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _dogumController = TextEditingController();
  final _adresController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final appt = context.read<AppointmentProvider>().currentAppointment;
      _adController.text = appt.ad;
      _soyadController.text = appt.soyad;
      _tcController.text = appt.tc;
      _emailController.text = appt.email;
      _telefonController.text = appt.telefon;
      _dogumController.text = appt.dogumTarihi;
      _adresController.text = appt.adres;
    }
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _tcController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _dogumController.dispose();
    _adresController.dispose();
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 1),
      locale: const Locale('tr'),
    );
    if (picked != null && mounted) {
      final formatted = Formatters.formatTarih(picked);
      _dogumController.text = formatted;
      if (mounted) {
        context.read<AppointmentProvider>().updateField('dogumTarihi', formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appt = provider.currentAppointment;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('input_ad'),
                    controller: _adController,
                    decoration: const InputDecoration(
                      labelText: 'Ad *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateAd,
                    onChanged: (v) => context.read<AppointmentProvider>().updateField('ad', v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('input_soyad'),
                    controller: _soyadController,
                    decoration: const InputDecoration(
                      labelText: 'Soyad *',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateSoyad,
                    onChanged: (v) => context.read<AppointmentProvider>().updateField('soyad', v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_tc'),
              controller: _tcController,
              decoration: const InputDecoration(
                labelText: 'TC Kimlik No *',
                prefixIcon: Icon(Icons.badge),
                hintText: '11 haneli TC kimlik no',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [TcInputFormatter()],
              validator: Validators.validateTc,
              onChanged: (v) => context.read<AppointmentProvider>().updateField('tc', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_email'),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta *',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
              onChanged: (v) => context.read<AppointmentProvider>().updateField('email', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_telefon'),
              controller: _telefonController,
              decoration: const InputDecoration(
                labelText: 'Telefon *',
                prefixIcon: Icon(Icons.phone),
                hintText: '05XX XXX XX XX',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneInputFormatter()],
              validator: Validators.validateTelefon,
              onChanged: (v) => context.read<AppointmentProvider>().updateField('telefon', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_dogum'),
              controller: _dogumController,
              decoration: InputDecoration(
                labelText: 'Doğum Tarihi *',
                prefixIcon: const Icon(Icons.cake),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: Validators.validateDogumTarihi,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_adres'),
              controller: _adresController,
              decoration: const InputDecoration(
                labelText: 'Adres *',
                prefixIcon: Icon(Icons.location_on),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: Validators.validateAdres,
              onChanged: (v) => context.read<AppointmentProvider>().updateField('adres', v),
            ),
            const SizedBox(height: 16),
            Text(
              'Cinsiyet *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    key: const ValueKey('radio_erkek'),
                    title: const Text('Erkek'),
                    value: 'erkek',
                    groupValue: appt.cinsiyet,
                    onChanged: (v) {
                      if (v != null) {
                        context.read<AppointmentProvider>().updateField('cinsiyet', v);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    key: const ValueKey('radio_kadin'),
                    title: const Text('Kadın'),
                    value: 'kadin',
                    groupValue: appt.cinsiyet,
                    onChanged: (v) {
                      if (v != null) {
                        context.read<AppointmentProvider>().updateField('cinsiyet', v);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
