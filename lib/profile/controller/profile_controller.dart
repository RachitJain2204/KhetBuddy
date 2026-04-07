import 'dart:io';
import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import '../repository/profile_repo.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  bool isLoading = false;
  String? error;

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required File? image,
  }) async {

    // ✅ Validation
    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
      error = "All fields are required";
      notifyListeners();
      return false;
    }

    if (image == null) {
      error = "Please select a profile image";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final model = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phoneNo: phone,
      );

      final response = await _repository.updateProfile(
        data: model,
        image: image,
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        return true;
      } else {
        error = "Something went wrong";
        return false;
      }
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}