import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/colors.dart';
class AddFarmPage extends StatefulWidget {
  const AddFarmPage({super.key});

  @override
  State<AddFarmPage> createState() => _AddFarmPageState();
}

class _AddFarmPageState extends State<AddFarmPage> {
  final TextEditingController landController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController customCropController = TextEditingController();

  String selectedIrrigation = '';
  List<String> selectedCrops = [];

  String latitude = '';
  String longitude = '';

  final List<String> irrigationTypes = [
    "Canal", "Drip", "Sprinkler", "Flood", "Furrow"
  ];

  final List<String> cropTypes = [
    "Wheat", "Rice", "Corn", "Barley", "Cotton", "Soybean"
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position.latitude.toStringAsFixed(5);
      longitude = position.longitude.toStringAsFixed(5);
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.hintText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hintText),
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.mainGreen),
        ),
      ),
    );
  }

  Widget _chips(List<String> items, bool singleSelect) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        bool isSelected = singleSelect
            ? selectedIrrigation == item
            : selectedCrops.contains(item);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (singleSelect) {
                selectedIrrigation = item;
              } else {
                isSelected
                    ? selectedCrops.remove(item)
                    : selectedCrops.add(item);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.lightGreen
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.mainGreen
                    : AppColors.cardBorder,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: isSelected
                    ? AppColors.darkgreen
                    : AppColors.textBlack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _disabledField(String value) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        value.isEmpty ? "Auto" : value,
        style: const TextStyle(
          color: AppColors.hintText,
          fontSize: 14,
        ),
      ),
    );
  }

  void _addCustomCrop() {
    if (customCropController.text.trim().isEmpty) return;

    setState(() {
      selectedCrops.add(customCropController.text.trim());
      customCropController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        title: const Text("Add New Farm"),
        backgroundColor: AppColors.bgcolor,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            _sectionTitle("TOTAL LAND (HECTARES)"),
            _textField(landController, "e.g. 10"),

            _sectionTitle("IRRIGATION TYPE"),
            _chips(irrigationTypes, true),

            _sectionTitle("PH LEVEL"),
            _textField(phController, "e.g. 7.8"),

            _sectionTitle("CROP TYPE"),
            _chips(cropTypes, false),

            const SizedBox(height: 10),

            // Custom crop input
            Row(
              children: [
                Expanded(
                  child: _textField(
                      customCropController, "Add custom crop"),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addCustomCrop,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.mainGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add,
                        color: AppColors.white),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),


            _sectionTitle("LATITUDE"),
            _disabledField(latitude),

            _sectionTitle("LONGITUDE"),
            _disabledField(longitude),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkgreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Save Farm",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}