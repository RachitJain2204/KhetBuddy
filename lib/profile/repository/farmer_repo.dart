import 'dart:io';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../model/farmer_model.dart';

class FarmerRepository {
  final ApiService _apiService = ApiService();

  // 🔹 GET Farmer Details
  Future<FarmerModel> getFarmerDetails() async {
    final response = await _apiService.get('/api/farmer/details');
    return FarmerModel.fromJson(response.data);
  }

  // 🔹 UPDATE Farmer Details
  Future<FarmerModel> updateFarmerDetails({
    required String firstName,
    required String lastName,
    required String phoneNo,
  }) async {
    final response = await _apiService.dio.patch(
      '/api/farmer/details',
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNo": phoneNo,
      },
    );

    return FarmerModel.fromJson(response.data);
  }

  // 🔹 UPDATE Profile Picture
  Future<String> updateProfileImage(File file) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
    });

    final response = await _apiService.dio.patch(
      '/api/farmer/profilePic',
      data: formData,
    );

    return response.data['profileImage'] ?? '';
  }
}