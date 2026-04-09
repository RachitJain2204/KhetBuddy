import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../farm/controller/farm_controller.dart';
import '../controller/farmer_controller.dart';
import '../controller/weather_controller.dart';
import '../controller/yield_controller.dart';
import '../widgets/farm_dashboard_header.dart';
import '../widgets/soil_analysis_card.dart';
import '../widgets/weather_card.dart';
import '../widgets/yield_forecast_card.dart';

/// The main dashboard screen.
class DashboardPage extends StatefulWidget {
  final int farmId;

  const DashboardPage({
    super.key,
    required this.farmId,
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
      context.read<YieldController>().fetchYield(widget.farmId);
      context.read<FarmerController>().fetchFarmer();
      context.read<FarmController>().fetchFarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ───────── HEADER (Farmer + Yield) ─────────
            Consumer3<FarmerController, YieldController, FarmController>(
              builder: (context, farmerCtrl, yieldCtrl, farmCtrl, child) {

                if (farmerCtrl.isLoading ||
                    yieldCtrl.isLoading ||
                    farmCtrl.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  );
                }

                final farmer = farmerCtrl.farmer;
                final yieldData = yieldCtrl.yieldData;
                final farm = farmCtrl.getFarmById(widget.farmId);

                if (farmer == null || yieldData == null || farm == null) {
                  return const Text("No data available");
                }

                return FarmDashboardHeader(
                  userName: farmer.firstName,
                  location:
                  "${yieldData.location.district}, ${yieldData.location.state}",
                  season: yieldData.season,

                  // 🔥 IMPORTANT CHANGES
                  crop: farm.crop, // from farm API (better than yield API)
                  area: "${farm.totalLand} acres", // ✅ dynamic
                  irrigation: farm.irrigationType, // ✅ dynamic
                );
              },
            ),

            const SizedBox(height: 4),

            /// ───────── SOIL ANALYSIS ─────────
            Consumer<YieldController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (controller.yieldData == null) {
                  return const Text("No soil data");
                }

                final soil = controller.yieldData!.soil;

                return SoilAnalysisCard(
                  nitrogen: soil.nitrogen,
                  phosphorus: soil.phosphorus,
                  potassium: soil.potassium,
                  moisture: soil.moisture,
                  soilPh: soil.soilPh,
                );
              },
            ),

            /// ───────── YIELD FORECAST ─────────
            Consumer<YieldController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (controller.yieldData == null) {
                  return const Text("No yield data");
                }

                final y = controller.yieldData!;

                return YieldForecastCard(
                  cropName: y.cropType,
                  minYield: y.yieldPerHectare.lower,
                  avgYield: y.yieldPerHectare.expected,
                  maxYield: y.yieldPerHectare.higher,
                  historicalData: const [], // optional
                );
              },
            ),

            /// ───────── WEATHER ─────────
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
                  windSpeed: w.windSpeed,
                  alertMessage: w.advisory,
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}