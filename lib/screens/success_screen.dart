import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../utils/formatters.dart';

class SuccessScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const SuccessScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Randevunuz Oluşturuldu!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Randevunuz başarıyla alınmıştır.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow(context, 'Randevu No', appointment.id.substring(0, 8).toUpperCase()),
                      const Divider(),
                      _infoRow(context, 'Ad Soyad', '${appointment.ad} ${appointment.soyad}'),
                      const Divider(),
                      _infoRow(context, 'Hastane', appointment.hastane),
                      const Divider(),
                      _infoRow(context, 'Bölüm', appointment.bolum),
                      const Divider(),
                      _infoRow(context, 'Doktor', appointment.doktorAdi),
                      if (appointment.randevuTarihi != null) ...[
                        const Divider(),
                        _infoRow(
                          context,
                          'Tarih',
                          Formatters.formatTarih(appointment.randevuTarihi!),
                        ),
                      ],
                      if (appointment.randevuSaati != null) ...[
                        const Divider(),
                        _infoRow(context, 'Saat', appointment.randevuSaati!),
                      ],
                      if (appointment.olusturmaTarihi != null) ...[
                        const Divider(),
                        _infoRow(
                          context,
                          'Oluşturulma',
                          Formatters.formatTarih(appointment.olusturmaTarihi!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Ana Sayfaya Dön'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
