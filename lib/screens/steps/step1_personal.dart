import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/appointment_provider.dart';
import '../../services/tc_validation_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/section_card.dart';

class Step1Personal extends StatefulWidget {
  const Step1Personal({super.key});

  @override
  State<Step1Personal> createState() => _Step1PersonalState();
}

class _Step1PersonalState extends State<Step1Personal> {
  late TextEditingController _adCtrl;
  late TextEditingController _soyadCtrl;
  late TextEditingController _tcCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telefonCtrl;
  late TextEditingController _dogumCtrl;
  late TextEditingController _adresCtrl;

  final _focusNodes = List.generate(7, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    final p = context.read<AppointmentProvider>();
    _adCtrl = TextEditingController(text: p.ad);
    _soyadCtrl = TextEditingController(text: p.soyad);
    _tcCtrl = TextEditingController(text: p.tc);
    _emailCtrl = TextEditingController(text: p.email);
    _telefonCtrl = TextEditingController(text: p.telefon);
    _dogumCtrl = TextEditingController(text: p.dogumTarihi);
    _adresCtrl = TextEditingController(text: p.adres);
  }

  @override
  void dispose() {
    for (final c in [
      _adCtrl, _soyadCtrl, _tcCtrl, _emailCtrl,
      _telefonCtrl, _dogumCtrl, _adresCtrl,
    ]) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDogumTarihi() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1920),
      lastDate: now,
      locale: const Locale('tr', 'TR'),
      helpText: 'Dogum Tarihi Secin',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final formatted = DateFormat('dd.MM.yyyy').format(picked);
      _dogumCtrl.text = formatted;
      context.read<AppointmentProvider>().updateDogumTarihi(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: provider.step1FormKey,
        child: Column(
          children: [
            const SizedBox(height: 8),
            SectionCard(
              title: 'Ad & Soyad',
              icon: Icons.person_outline_rounded,
              child: Column(
                children: [
                  _buildTextField(
                    key: const ValueKey('input_ad'),
                    controller: _adCtrl,
                    label: 'Ad *',
                    hint: 'Adinizi girin',
                    focusNode: _focusNodes[0],
                    nextFocus: _focusNodes[1],
                    validator: Validators.validateAd,
                    onChanged: provider.updateAd,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    key: const ValueKey('input_soyad'),
                    controller: _soyadCtrl,
                    label: 'Soyad *',
                    hint: 'Soyadinizi girin',
                    focusNode: _focusNodes[1],
                    nextFocus: _focusNodes[2],
                    validator: Validators.validateSoyad,
                    onChanged: provider.updateSoyad,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: Icons.badge_outlined,
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'TC Kimlik No',
              icon: Icons.credit_card_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const ValueKey('input_tc'),
                    controller: _tcCtrl,
                    focusNode: _focusNodes[2],
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                    decoration: _inputDecoration(
                      label: 'TC Kimlik No *',
                      hint: '10000000146',
                      prefixIcon: Icons.credit_card_outlined,
                      suffix: _buildTcSuffix(provider),
                    ),
                    onChanged: (v) {
                      provider.updateTc(v);
                    },
                    onEditingComplete: () {
                      _focusNodes[2].unfocus();
                      _focusNodes[3].requestFocus();
                      if (_tcCtrl.text.length == 11) {
                        provider.checkTcAsync();
                      }
                    },
                    validator: Validators.validateTc,
                  ),
                  if (provider.tcCheckState == TcCheckState.invalid &&
                      provider.tcCheckMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 12),
                      child: Text(
                        provider.tcCheckMessage!,
                        style: GoogleFonts.poppins(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (provider.tcCheckState == TcCheckState.valid)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              provider.tcCheckMessage ?? 'TC dogrulandi',
                              style: GoogleFonts.poppins(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SectionCard(
              title: 'Iletisim Bilgileri',
              icon: Icons.contact_phone_outlined,
              child: Column(
                children: [
                  _buildTextField(
                    key: const ValueKey('input_email'),
                    controller: _emailCtrl,
                    label: 'E-posta *',
                    hint: 'ornek@mail.com',
                    focusNode: _focusNodes[3],
                    nextFocus: _focusNodes[4],
                    validator: Validators.validateEmail,
                    onChanged: provider.updateEmail,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('input_telefon'),
                    controller: _telefonCtrl,
                    focusNode: _focusNodes[4],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [PhoneInputFormatter()],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _inputDecoration(
                      label: 'Telefon *',
                      hint: '0(5XX) XXX XX XX',
                      prefixIcon: Icons.phone_outlined,
                    ),
                    onChanged: provider.updateTelefon,
                    onEditingComplete: () {
                      _focusNodes[4].unfocus();
                      _focusNodes[5].requestFocus();
                    },
                    validator: Validators.validateTelefon,
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'Dogum Tarihi & Cinsiyet',
              icon: Icons.cake_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _selectDogumTarihi,
                    child: AbsorbPointer(
                      child: TextFormField(
                        key: const ValueKey('input_dogum'),
                        controller: _dogumCtrl,
                        focusNode: _focusNodes[5],
                        keyboardType: TextInputType.datetime,
                        decoration: _inputDecoration(
                          label: 'Dogum Tarihi *',
                          hint: 'gg.aa.yyyy',
                          prefixIcon: Icons.calendar_today_outlined,
                          suffix: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryUltraLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.edit_calendar_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                        validator: Validators.validateDogumTarihi,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cinsiyet *',
                    style: GoogleFonts.poppins(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderCard(
                          context,
                          label: 'Erkek',
                          value: 'Erkek',
                          icon: Icons.male_rounded,
                          selected: provider.cinsiyet == 'Erkek',
                          radioKey: const ValueKey('radio_erkek'),
                          groupValue: provider.cinsiyet,
                          onChanged: (v) {
                            if (v != null) provider.updateCinsiyet(v);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildGenderCard(
                          context,
                          label: 'Kadin',
                          value: 'Kadın',
                          icon: Icons.female_rounded,
                          selected: provider.cinsiyet == 'Kadın',
                          radioKey: const ValueKey('radio_kadin'),
                          groupValue: provider.cinsiyet,
                          onChanged: (v) {
                            if (v != null) provider.updateCinsiyet(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'Adres',
              icon: Icons.location_on_outlined,
              child: TextFormField(
                key: const ValueKey('input_adres'),
                controller: _adresCtrl,
                focusNode: _focusNodes[6],
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                minLines: 2,
                decoration: _inputDecoration(
                  label: 'Adres *',
                  hint: 'Tam adresinizi girin (min. 10 karakter)',
                  prefixIcon: Icons.home_outlined,
                ),
                onChanged: provider.updateAdres,
                validator: Validators.validateAdres,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String hint,
    required FocusNode focusNode,
    required FocusNode? nextFocus,
    required String? Function(String?) validator,
    required ValueChanged<String> onChanged,
    TextInputType inputType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      textCapitalization: capitalization,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        prefixIcon: prefixIcon,
      ),
      onChanged: onChanged,
      onEditingComplete: () {
        focusNode.unfocus();
        nextFocus?.requestFocus();
      },
      validator: validator,
    );
  }

  Widget _buildGenderCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required bool selected,
    required Key radioKey,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryUltraLight
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
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
        child: Row(
          children: [
            Radio<String>(
              key: radioKey,
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.subtitle,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.bodyText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTcSuffix(AppointmentProvider provider) {
    switch (provider.tcCheckState) {
      case TcCheckState.checking:
        return const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        );
      case TcCheckState.valid:
        return const Icon(Icons.check_circle,
            color: AppColors.success, size: 20);
      case TcCheckState.invalid:
        return const Icon(Icons.error_outline,
            color: AppColors.error, size: 20);
      case TcCheckState.idle:
        return const SizedBox.shrink();
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 20, color: AppColors.subtitle)
          : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide:
            const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
          color: AppColors.subtitle, fontSize: 14),
      hintStyle: GoogleFonts.poppins(
          color: AppColors.disabled, fontSize: 14),
      errorStyle: GoogleFonts.poppins(
          color: AppColors.error, fontSize: 12),
      counterText: '',
    );
  }
}
