import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class WeatherCard extends StatelessWidget {
  final double temperature;
  final int humidity;
  final double rainfall;
  final double windSpeed;
  final String alertMessage;

  const WeatherCard({
    super.key,
    this.temperature = 26,
    this.humidity = 75,
    this.rainfall = 6.9,
    this.windSpeed = 11,
    this.alertMessage = 'Moderate rainfall expected. Delay fertilizer application by 1-2 days.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.weatherBlue, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.weatherBlueBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cloud_outlined, color: AppColors.weatherBlue, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Today's Weather",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weather stats row
            Row(
              children: [
                Expanded(
                  child: _WeatherStat(
                    icon: Icons.thermostat_outlined,
                    iconColor: const Color(0xFFE65100),
                    iconBg: const Color(0xFFFFF3EE),
                    value: '${temperature.toInt()}°C',
                    label: 'Temperature',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WeatherStat(
                    icon: Icons.water_drop_outlined,
                    iconColor: AppColors.weatherBlue,
                    iconBg: AppColors.weatherBlueBg,
                    value: '$humidity%',
                    label: 'Humidity',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WeatherStat(
                    icon: Icons.grain_rounded,
                    iconColor: const Color(0xFF546E7A),
                    iconBg: const Color(0xFFECEFF1),
                    value: '${rainfall}mm',
                    label: 'Rainfall',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WeatherStat(
                    icon: Icons.air_rounded,
                    iconColor: const Color(0xFF607D8B),
                    iconBg: const Color(0xFFECEFF1),
                    value: '${windSpeed.toInt()}km/h',
                    label: 'Wind',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Alert banner
            if (alertMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.weatherAlertBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.weatherBlue.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.weatherAlertText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alertMessage,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.weatherAlertText,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  const _WeatherStat({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: iconBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.hintText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}