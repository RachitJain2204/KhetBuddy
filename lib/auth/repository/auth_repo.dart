import '../../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // =========================
  // 🔐 SIGN UP
  // =========================
  Future<bool> signUp(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/signUp',
        {
          "username": username,
          "password": password,
        },
      );

      final data = response.data;

      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      await _apiService.setAuthToken(accessToken);
      await _apiService.setRefreshToken(refreshToken);

      return true;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // 🔐 LOGIN
  // =========================
  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        {
          "username": username,
          "password": password,
        },
      );

      final data = response.data;

      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      await _apiService.setAuthToken(accessToken);
      await _apiService.setRefreshToken(refreshToken);

      return true;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // 🔁 REFRESH TOKEN
  // =========================
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _apiService.getRefreshToken();

      if (refreshToken == null) return null;

      final response = await _apiService.post(
        '/auth/refresh',
        {
          "refreshToken": refreshToken,
        },
      );

      final newAccessToken = response.data['accessToken'];

      await _apiService.setAuthToken(newAccessToken);

      return newAccessToken;
    } catch (e) {
      return null;
    }
  }
}