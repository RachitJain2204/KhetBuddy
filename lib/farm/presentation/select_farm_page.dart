import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/add_new_farm_card.dart';
import '../widgets/farm_card.dart';

class SelectFarmPage extends StatefulWidget {
  const SelectFarmPage({super.key});

  @override
  State<SelectFarmPage> createState() => _SelectFarmPageState();
}

class _SelectFarmPageState extends State<SelectFarmPage> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> farms = [
    {
      "name": "Rice",
      "land": "32 hectares",
      "irrigation": "Drip",
      "ph": "6.6",
      "location": "23.951, 26.096"
    },
    {
      "name": "Corn",
      "land": "10 hectares",
      "irrigation": "Sprinkler",
      "ph": "7.9",
      "location": "22.662, 26.464"
    },
    {
      "name": "Barley",
      "land": "50 hectares",
      "irrigation": "Canal",
      "ph": "7.6",
      "location": "22.399, 25.460"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Step indicator
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

              // Farm List
              Expanded(
                child: ListView.builder(
                  itemCount: farms.length + 1,
                  itemBuilder: (context, index) {
                    if (index == farms.length) {
                      return const AddFarmCard();
                    }

                    final farm = farms[index];

                    return FarmCard(
                      farm: farm,
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

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
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