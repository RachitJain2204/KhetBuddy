import 'package:flutter/material.dart';
import '../model/yield_model.dart';
import '../repository/yield_repo.dart';

class YieldController extends ChangeNotifier {
  final YieldRepository _repository = YieldRepository();

  YieldResponse? yieldData; // ✅ renamed
  bool isLoading = false;
  String? error;

  Future<void> fetchYield(int farmId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      yieldData = await _repository.getYieldPrediction(farmId); // ✅ fixed
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}