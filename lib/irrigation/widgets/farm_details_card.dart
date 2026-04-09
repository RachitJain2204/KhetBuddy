import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';

class FarmDetailsCard extends StatefulWidget {
  const FarmDetailsCard({super.key});

  @override
  State<FarmDetailsCard> createState() => _FarmDetailsCardState();
}

class _FarmDetailsCardState extends State<FarmDetailsCard> {
  final TextEditingController _lastIrrigationCtrl = TextEditingController();
  final TextEditingController _sowingDateCtrl = TextEditingController();
  final TextEditingController _hoursCtrl = TextEditingController();
  String? _soilType;
  String? _pumpType;

  final List<String> _soilTypes = ['loamy', 'sandy', 'clay', 'silt', 'peaty'];
  final List<String> _pumpTypes = ['small', 'medium', 'large'];

  @override
  void dispose() {
    _lastIrrigationCtrl.dispose();
    _sowingDateCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.irrigationPrimary,
            onPrimary: AppColors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _sowingDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.irrigationPrimary.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.irrigationPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.irrigateBadgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.water_drop_outlined,
                            color: AppColors.irrigationPrimary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Your Farm Details',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('LAST IRRIGATION (DAYS AGO)'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _lastIrrigationCtrl,
                      hint: 'e.g. 2',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('SOWING DATE'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _sowingDateCtrl,
                          hint: 'Select date',
                          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.hintText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('SOIL TYPE'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _soilType,
                      hint: 'Select soil type',
                      items: _soilTypes,
                      onChanged: (v) => setState(() => _soilType = v),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('AVG. DAILY IRRIGATION (HOURS)'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _hoursCtrl,
                      hint: 'e.g. 2',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('PUMP TYPE'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _pumpType,
                      hint: 'Select pump type',
                      items: _pumpTypes,
                      onChanged: (v) => setState(() => _pumpType = v),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.hintText,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.textBlack,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 14),
        filled: true,
        fillColor: AppColors.inputBg,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.irrigationPrimary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: AppColors.hintText, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.hintText),
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}