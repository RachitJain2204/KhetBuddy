import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../widgets/action_button.dart';
import '../widgets/daily_plan_list.dart';
import '../widgets/farm_details_card.dart';
import '../widgets/irrigation_header.dart';
import '../widgets/schedule_summer_banner.dart';
import '../widgets/today_irrigation_card.dart';

class IrrigationPage extends StatefulWidget {
  const IrrigationPage({super.key});

  @override
  State<IrrigationPage> createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  // View toggle: 'form' | 'schedule' | 'today'
  String _activeView = 'form';

  // Dummy farm data (replaces FarmDetailsModel)
  final Map<String, dynamic> _farmDetails = {
    'lastIrrigationDaysAgo': 2,
    'sowingDate': DateTime(2026, 4, 8),
    'soilType': 'loamy',
    'avgDailyIrrigationHours': 2,
    'pumpType': 'medium',
    'cropName': 'Wheat',
  };

  // Schedule generator (returns Map list instead of IrrigationDayModel)
  List<Map<String, dynamic>> get _schedule => _generateSchedule();

  List<Map<String, dynamic>> _generateSchedule() {
    final now = DateTime.now();
    final irrigateDays = {0, 3, 6, 9, 12};

    return List.generate(14, (i) {
      final date = now.add(Duration(days: i));
      final shouldIrrigate = irrigateDays.contains(i);

      return {
        'dayNumber': i + 1,
        'date': date,
        'shouldIrrigate': shouldIrrigate,
        'hours': shouldIrrigate
            ? _farmDetails['avgDailyIrrigationHours']
            : 0,
        'cycles': shouldIrrigate ? 1 : 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Column(
        children: [

          // Header
          IrrigationHeader(cropName: _farmDetails['cropName']),

          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Farm Details (now static/dummy UI inside widget)
                  const FarmDetailsCard(),
                  const SizedBox(height: 16),

                  // Buttons
                  ActionButtonsRow(
                    onScheduleTap: () =>
                        setState(() => _activeView = 'schedule'),
                    onTodayTap: () =>
                        setState(() => _activeView = 'today'),
                    activeView: _activeView,
                  ),
                  const SizedBox(height: 16),

                  // Schedule View
                  if (_activeView == 'schedule') ...[
                    ScheduleSummaryBanner(
                      totalDays: 14,
                      totalWaterHours: 10,
                      irrigationCount: 5,
                      soilType: _farmDetails['soilType'],
                      pumpType: _farmDetails['pumpType'],
                    ),
                    const SizedBox(height: 12),
                    DailyPlanList(days: _schedule),
                  ],

                  // Today View
                  if (_activeView == 'today') ...[
                    TodayIrrigationCard(
                      hours: _farmDetails['avgDailyIrrigationHours'],
                      cycles: 1,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}