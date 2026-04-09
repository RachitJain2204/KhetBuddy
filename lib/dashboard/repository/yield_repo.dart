import '../../services/api_service.dart';
import '../model/yield_model.dart';

class YieldRepository {
  final ApiService _apiService = ApiService();

  Future<YieldResponse> getYieldPrediction(int farmId) async {
    try {
      final response = await _apiService.post(
        '/api/yield/predict/$farmId',
        {}, // no body required
      );

      return YieldResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch yield prediction: $e");
    }
  }
}