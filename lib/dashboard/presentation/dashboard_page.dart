import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../controller/weather_controller.dart';
import '../widgets/farm_dashboard_header.dart';
import '../widgets/soil_analysis_card.dart';
import '../widgets/weather_card.dart';
import '../widgets/yield_forecast_card.dart';


/// The main dashboard screen.
/// Compose all card widgets here — easy to reorder, add, or remove sections.
class DashboardPage extends StatefulWidget {
  final farmId;
  const DashboardPage({
    super.key,
    required this.farmId
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<WeatherController>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── 1. Green header with farm info ──────────────────────────
            const FarmDashboardHeader(
              userName: 'Ravi',
              location: 'New Delhi, Delhi',
              season: 'Rabi (Spring)',
              crop: 'Wheat',
              area: '5 acres',
              irrigation: 'Drip',
            ),

            const SizedBox(height: 4),

            // ── 2. Soil Analysis ─────────────────────────────────────────
            const SoilAnalysisCard(
              nitrogen: 281,
              phosphorus: 23,
              potassium: 213,
              moisture: 52,
              soilPh: 6.8,
            ),

            // ── 3. Yield Forecast + Historical Chart ─────────────────────
            const YieldForecastCard(
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
            Consumer<WeatherController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (controller.weather == null) {
                  return const Text("No weather data");
                }

                final w = controller.weather!;

                return WeatherCard(
                  temperature: w.avgTemperature,
                  humidity: w.humidity.toInt(),
                  rainfall: w.rainfallToday,
                  windSpeed: w.windSpeed,
                  alertMessage: w.advisory,
                );
              },
            ),

            // Bottom padding so content clears the nav bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}