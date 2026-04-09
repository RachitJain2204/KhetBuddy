import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class SoilAnalysisCard extends StatelessWidget {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;
  final double soilPh;

  const SoilAnalysisCard({
    super.key,
    this.nitrogen = 281,
    this.phosphorus = 23,
    this.potassium = 213,
    this.moisture = 52,
    this.soilPh = 6.8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.offwhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.layers_outlined, color: AppColors.textBlack, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Soil Analysis',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textBlack),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // N, P, K boxes
          Row(
            children: [
              Expanded(
                child: _NutrientBox(
                  label: 'N',
                  value: nitrogen,
                  color: AppColors.nitrogenGreen,
                  bgColor: AppColors.nitrogenBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _NutrientBox(
                  label: 'P',
                  value: phosphorus,
                  color: AppColors.phosphorusOrange,
                  bgColor: AppColors.phosphorusBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _NutrientBox(
                  label: 'K',
                  value: potassium,
                  color: AppColors.potassiumPurple,
                  bgColor: AppColors.potassiumBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Moisture + pH
          Row(
            children: [
              Expanded(
                child: _StatusBox(
                  icon: Icons.water_drop_outlined,
                  iconColor: AppColors.weatherBlue,
                  value: '${moisture.toInt()}%',
                  label: 'Moisture',
                  bgColor: AppColors.weatherBlueBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatusBox(
                  icon: Icons.show_chart_rounded,
                  iconColor: AppColors.phosphorusOrange,
                  value: 'pH $soilPh',
                  label: 'Soil pH',
                  bgColor: AppColors.phosphorusBg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientBox extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final Color bgColor;

  const _NutrientBox({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
              Text(
                value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 4),
          const Text('kg/ha', style: TextStyle(fontSize: 11, color: AppColors.hintText)),
        ],
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color bgColor;

  const _StatusBox({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: iconColor)),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.hintText)),
            ],
          ),
        ],
      ),
    );
  }
}