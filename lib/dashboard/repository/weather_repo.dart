import '../../services/api_service.dart';
import '../model/weather_model.dart';

class WeatherRepository {
  final ApiService _apiService = ApiService();

  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await _apiService.get(
      '/weather/current?lat=$lat&lon=$lon',
    );

    return WeatherModel.fromJson(response.data);
  }
}