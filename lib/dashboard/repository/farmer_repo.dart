import '../../services/api_service.dart';
import '../model/farmer_model.dart';

class FarmerRepository {
  final ApiService _apiService = ApiService();

  Future<Farmer> getFarmerDetails() async {
    try {
      final response = await _apiService.get('/api/farmer/details');

      return Farmer.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch farmer details: $e");
    }
  }
}