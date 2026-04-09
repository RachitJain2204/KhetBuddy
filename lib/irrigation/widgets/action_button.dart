import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback onTodayTap;
  final String activeView;

  const ActionButtonsRow({
    super.key,
    required this.onScheduleTap,
    required this.onTodayTap,
    required this.activeView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.calendar_month_outlined,
            label: '14-Day Schedule',
            isActive: activeView == 'schedule',
            isPrimary: true,
            onTap: onScheduleTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.water_drop_outlined,
            label: 'Today',
            isActive: activeView == 'today',
            isPrimary: false,
            onTap: onTodayTap,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool filled = isPrimary || isActive;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? AppColors.irrigationPrimary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled ? AppColors.irrigationPrimary : AppColors.irrigateBadgeBorder,
            width: 1.5,
          ),
          boxShadow: filled
              ? [
            BoxShadow(
              color: AppColors.irrigationPrimary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: filled ? AppColors.white : AppColors.irrigationPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: filled ? AppColors.white : AppColors.irrigationPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}