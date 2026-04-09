import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/farm_dashboard_header.dart';
import '../widgets/soil_analysis_card.dart';
import '../widgets/weather_card.dart';
import '../widgets/yield_forecast_card.dart';


/// The main dashboard screen.
/// Compose all card widgets here — easy to reorder, add, or remove sections.
class DashboardPage extends StatelessWidget {
  final farmId;
  const DashboardPage({
    super.key,
    required this.farmId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // ── 1. Green header with farm info ──────────────────────────
            FarmDashboardHeader(
              userName: 'Ravi',
              location: 'New Delhi, Delhi',
              season: 'Rabi (Spring)',
              crop: 'Wheat',
              area: '5 acres',
              irrigation: 'Drip',
            ),

            SizedBox(height: 4),

            // ── 2. Soil Analysis ─────────────────────────────────────────
            SoilAnalysisCard(
              nitrogen: 281,
              phosphorus: 23,
              potassium: 213,
              moisture: 52,
              soilPh: 6.8,
            ),

            // ── 3. Yield Forecast + Historical Chart ─────────────────────
            YieldForecastCard(
              cropName: 'Wheat',
              minYield: 10.5,
              avgYield: 17.5,
              maxYield: 23.63,
              historicalData: [
                YieldDataPoint(year: '\'22', value: 16.7),
                YieldDataPoint(year: '\'23', value: 16.8),
                YieldDataPoint(year: '\'24', value: 19.9, isHighlighted: true),
                YieldDataPoint(year: '\'25', value: 16.9),
                YieldDataPoint(year: '\'26', value: 16.5),
                YieldDataPoint(year: 'Max', value: 23.6, isMaxPotential: true),
              ],
            ),

            // ── 4. Today's Weather ───────────────────────────────────────
            WeatherCard(
              temperature: 26,
              humidity: 75,
              rainfall: 6.9,
              windSpeed: 11,
              alertMessage:
              'Moderate rainfall expected. Delay fertilizer application by 1-2 days.',
            ),

            // Bottom padding so content clears the nav bar
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}