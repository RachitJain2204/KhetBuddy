import 'package:flutter/material.dart';
import '../model/farm_model.dart';
import '../repository/farm_repo.dart';

class FarmController extends ChangeNotifier {
  final FarmRepository _repository = FarmRepository();

  List<FarmModel> farms = [];
  bool isLoading = false;
  String? error;

  // 🔄 Fetch farms
  Future<void> fetchFarms() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      farms = await _repository.getUserFarms();
    } catch (e) {
      error = e.toString();
      farms = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addFarm({
    required double totalLand,
    required String irrigationType,
    required String phLevel,
    required String crop,
    required double latitude,
    required double longitude,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final newFarm = await _repository.addFarm(
        totalLand: totalLand,
        irrigationType: irrigationType,
        phLevel: phLevel,
        crop: crop,
        latitude: latitude,
        longitude: longitude,
      );

      farms.add(newFarm); // optional (instant UI update)

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  FarmModel? getFarmById(int id) {
    try {
      return farms.firstWhere((farm) => farm.id == id);
    } catch (e) {
      return null;
    }
  }
}