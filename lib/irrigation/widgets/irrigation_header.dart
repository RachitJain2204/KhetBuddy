import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class IrrigationHeader extends StatelessWidget {
  final String cropName;

  const IrrigationHeader({super.key, required this.cropName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 69, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E5AA8), // top blue
            Color(0xFF2D6FBE), // bottom blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          // Text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Irrigation Planner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Personalized schedule for $cropName',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}