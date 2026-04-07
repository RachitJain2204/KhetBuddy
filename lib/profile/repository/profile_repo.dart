import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import 'package:http_parser/http_parser.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<Response> updateProfile({
    required ProfileModel data,
    required File image,
  }) async {

    final formData = FormData.fromMap({
      // ✅ SEND JSON AS FILE-LIKE PART
      "data": MultipartFile.fromString(
        jsonEncode(data.toJson()),
        contentType: MediaType('application', 'json'),
      ), // 🔥 VERY IMPORTANT

      "file": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    return await _apiService.dio.post(
      "/farmer/details",
      data: formData,
    );
  }
}