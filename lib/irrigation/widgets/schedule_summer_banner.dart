import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ScheduleSummaryBanner extends StatelessWidget {
  final int totalDays;
  final int totalWaterHours;
  final int irrigationCount;
  final String soilType;
  final String pumpType;

  const ScheduleSummaryBanner({
    super.key,
    required this.totalDays,
    required this.totalWaterHours,
    required this.irrigationCount,
    required this.soilType,
    required this.pumpType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats banner — solid blue matching the original
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.irrigationPrimary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.irrigationPrimary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _StatItem(value: '$totalDays', label: 'Days'),
              _Divider(),
              _StatItem(value: '${totalWaterHours}h', label: 'Total Water'),
              _Divider(),
              _StatItem(value: '$irrigationCount', label: 'Irrigations'),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Info note — light blue
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.infoBannerBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.irrigateBadgeBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.irrigationPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your $soilType soil with $pumpType pump requires $irrigationCount irrigation days over the next 2 weeks.',
                  style: const TextStyle(
                    color: AppColors.infoBannerText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 1,
      color: AppColors.white.withOpacity(0.2),
    );
  }
}