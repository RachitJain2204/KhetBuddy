import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TodayIrrigationCard extends StatelessWidget {
  final int hours;
  final int cycles;

  const TodayIrrigationCard({
    super.key,
    required this.hours,
    required this.cycles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.irrigationPrimary.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — solid blue
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.irrigationPrimary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Icon(Icons.water_drop, color: AppColors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Irrigate Today',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Container(
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stat tiles
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        value: '${hours}h',
                        label: 'Duration',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        value: '$cycles',
                        label: 'Cycles',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Info tip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.infoBannerBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.irrigateBadgeBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: AppColors.irrigationPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Irrigate today for $hours hour${hours > 1 ? 's' : ''} split into $cycles cycle${cycles > 1 ? 's' : ''}. Water early morning or late evening for best results.',
                          style: const TextStyle(
                            color: AppColors.infoBannerText,
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;

  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.todayStatBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.irrigationPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.irrigationPrimary.withOpacity(0.65),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}