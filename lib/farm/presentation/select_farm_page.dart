import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ADDED
import '../../app_routes.dart';
import '../../constants/colors.dart';
import '../controller/farm_controller.dart';
import '../model/farm_model.dart';
import '../widgets/add_new_farm_card.dart';
import '../widgets/farm_card.dart';

class SelectFarmPage extends StatefulWidget {
  const SelectFarmPage({super.key});

  @override
  State<SelectFarmPage> createState() => _SelectFarmPageState();
}

class _SelectFarmPageState extends State<SelectFarmPage> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FarmController>().fetchFarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FarmController>();
    final farms = controller.farms;

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.mainGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "STEP 2 OF 2",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Select a Farm",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Choose the farm you want to manage right now",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textBlack,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "${farms.length} FARMS FOUND",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: farms.isEmpty ? 1 : farms.length + 1,
                  itemBuilder: (context, index) {
                    if (farms.isEmpty) {
                      return const AddFarmCard();
                    }

                    if (index == farms.length) {
                      return const AddFarmCard();
                    }

                    final FarmModel farm = farms[index];

                    return FarmCard(
                      farm: {
                        "name": farm.crop,
                        "land": "${farm.totalLand} hectares",
                        "irrigation": farm.irrigationType,
                        "ph": farm.phLevel.toString(),
                        "location":
                        "${farm.latitude}, ${farm.longitude}",
                      },
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () async {
                    final selectedFarm = farms[selectedIndex!];

                    final prefs = await SharedPreferences.getInstance();

                    // ✅ SAVE FARM ID
                    await prefs.setInt('selected_farm_id', selectedFarm.id);

                    // ✅ NAVIGATE
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                      arguments: selectedFarm.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue with Selected Farm",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}