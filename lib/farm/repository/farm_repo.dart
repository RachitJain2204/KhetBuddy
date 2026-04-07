import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../model/farm_model.dart';

class FarmRepository {
  final ApiService _apiService = ApiService();

  Future<List<FarmModel>> getUserFarms() async {
    try {
      final Response response =
      await _apiService.get('/farm/my-farms');

      final List data = response.data;

      return data.map((e) => FarmModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch farms: $e");
    }
  }

  Future<FarmModel> addFarm({
    required double totalLand,
    required String irrigationType,
    required String phLevel,
    required String crop,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Response response = await _apiService.post(
        '/farm/add',
        {
          "total_land": totalLand,
          "irrigation_type": irrigationType,
          "ph_level": phLevel,
          "crop": crop,
          "latitude": latitude,
          "longitude": longitude,
        },
      );

      return FarmModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to add farm: $e");
    }
  }
}