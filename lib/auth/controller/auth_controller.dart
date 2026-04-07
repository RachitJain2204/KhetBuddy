import 'package:flutter/material.dart';

import '../repository/auth_repo.dart';


class AuthController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  // =========================
  // 🔐 SIGN UP
  // =========================
  Future<bool> signUp(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await _repository.signUp(username, password);

    if (!success) {
      errorMessage = "Signup failed. Try again.";
    }

    isLoading = false;
    notifyListeners();

    return success;
  }

  // =========================
  // 🔐 LOGIN
  // =========================
  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await _repository.login(username, password);

    if (!success) {
      errorMessage = "Login failed. Check credentials.";
    }

    isLoading = false;
    notifyListeners();

    return success;
  }
}