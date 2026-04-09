import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FarmDashboardHeader extends StatelessWidget {
  final String userName;
  final String location;
  final String season;
  final String crop;
  final String area;
  final String irrigation;

  const FarmDashboardHeader({
    super.key,
    this.userName = 'Ravi',
    this.location = 'New Delhi, Delhi',
    this.season = 'Rabi (Spring)',
    this.crop = 'Wheat',
    this.area = '5 acres',
    this.irrigation = 'Drip',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkgreen,
      padding: const EdgeInsets.only(top: 56, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Avatar row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Namaste, $userName',
                    style: const TextStyle(
                      color: Color(0xFFB8E4C9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'My Farm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A6E3C),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6AAF85), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location + season row
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFFB8E4C9), size: 14),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(color: Color(0xFFB8E4C9), fontSize: 13)),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Color(0xFFB8E4C9))),
              const SizedBox(width: 8),
              const Icon(Icons.wb_sunny_outlined, color: Color(0xFFB8E4C9), size: 14),
              const SizedBox(width: 4),
              Text(season, style: const TextStyle(color: Color(0xFFB8E4C9), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Tags row
          Row(
            children: [
              _FarmTag(icon: Icons.grid_view_rounded, label: crop),
              const SizedBox(width: 8),
              _FarmTag(icon: Icons.open_in_full_rounded, label: area),
              const SizedBox(width: 8),
              _FarmTag(icon: Icons.water_drop_outlined, label: irrigation),
            ],
          ),
        ],
      ),
    );
  }
}

class _FarmTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FarmTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A6E3C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}