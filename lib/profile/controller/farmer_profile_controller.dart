import 'dart:io';
import 'package:flutter/material.dart';
import '../model/farmer_model.dart';
import '../repository/farmer_repo.dart';

class FarmerProfileController extends ChangeNotifier {
  final FarmerRepository _repo = FarmerRepository();

  FarmerModel? farmer;
  bool isLoading = false;
  String? error;

  // 🔹 Fetch Profile
  Future<void> fetchFarmer() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      farmer = await _repo.getFarmerDetails();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 Update Profile (Text)
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNo,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final updated = await _repo.updateFarmerDetails(
        firstName: firstName,
        lastName: lastName,
        phoneNo: phoneNo,
      );

      farmer = updated;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 Update Profile Image
  Future<void> updateProfileImage(File file) async {
    isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await _repo.updateProfileImage(file);

      if (farmer != null) {
        farmer = farmer!.copyWith(profileImage: imageUrl);
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}