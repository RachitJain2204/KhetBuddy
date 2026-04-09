import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';

class DailyPlanList extends StatelessWidget {
  final List<Map<String, dynamic>> days;

  const DailyPlanList({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.irrigateBadgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.format_list_bulleted_rounded,
                    color: AppColors.irrigationPrimary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Daily Plan',
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.cardBorder),
            itemBuilder: (context, index) =>
                DailyPlanItem(day: days[index]),
          ),
        ],
      ),
    );
  }
}

class DailyPlanItem extends StatelessWidget {
  final Map<String, dynamic> day;

  const DailyPlanItem({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM').format(day['date']);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Day badge
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: day['shouldIrrigate']
                  ? AppColors.irrigationPrimary
                  : AppColors.inputBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day['dayNumber']}',
              style: TextStyle(
                color: day['shouldIrrigate']
                    ? AppColors.white
                    : AppColors.hintText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Date + info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    color: day['shouldIrrigate']
                        ? AppColors.textBlack
                        : AppColors.textBlack.withOpacity(0.6),
                    fontSize: 15,
                    fontWeight: day['shouldIrrigate']
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                if (day['shouldIrrigate']) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${day['hours']}h  ${day['cycles']} cycle(s)',
                    style: const TextStyle(
                      color: AppColors.hintText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Chip
          if (day['shouldIrrigate']) _IrrigateChip() else _SkipChip(),
        ],
      ),
    );
  }
}

class _IrrigateChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.irrigateBadgeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.irrigateBadgeBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop_outlined,
              size: 13, color: AppColors.irrigationPrimary),
          SizedBox(width: 4),
          Text(
            'Irrigate',
            style: TextStyle(
              color: AppColors.irrigationPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.skipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove, size: 13, color: AppColors.skipText),
          SizedBox(width: 4),
          Text(
            'Skip',
            style: TextStyle(
              color: AppColors.skipText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

