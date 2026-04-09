import 'package:flutter/material.dart';
import '../model/farmer_model.dart';
import '../repository/farmer_repo.dart';

class FarmerController extends ChangeNotifier {
  final FarmerRepository _repository = FarmerRepository();

  Farmer? farmer;
  bool isLoading = false;
  String? error;

  Future<void> fetchFarmer() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      farmer = await _repository.getFarmerDetails();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}