import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/weather_model.dart';
import '../repository/weather_repo.dart';

class WeatherController extends ChangeNotifier {

  final WeatherRepository _repo = WeatherRepository();

  WeatherModel? weather;
  bool isLoading = false;
  String? error;

  Future<void> fetchWeather() async {
    try {
      isLoading = true;
      notifyListeners();

      // 📍 Step 1: Get location
      Position position = await _getCurrentLocation();

      // 🌦 Step 2: Call API
      weather = await _repo.getWeather(
        lat: position.latitude,
        lon: position.longitude,
      );

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // 📍 Location Logic
  // =========================

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if location enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}