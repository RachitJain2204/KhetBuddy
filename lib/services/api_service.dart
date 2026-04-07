import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/repository/auth_repo.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://khetbuddy-backend.onrender.com/',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 600),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  bool _isRefreshing = false;
  final List<Function(String)> _subscribers = [];

  ApiService._internal() {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final requestOptions = error.requestOptions;

          // ⚠️ If backend changes status code, update here
          if (error.response?.statusCode == 401) {

            // 🔁 If already refreshing → queue requests
            if (_isRefreshing) {
              _subscribeTokenRefresh((token) async {
                requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(requestOptions);
                handler.resolve(response);
              });
              return;
            }

            _isRefreshing = true;

            final authRepository = AuthRepository();
            final newToken = await authRepository.refreshAccessToken();

            _isRefreshing = false;

            if (newToken != null) {
              _onRefreshed(newToken);

              _dio.options.headers['Authorization'] = 'Bearer $newToken';

              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final response = await _dio.fetch(requestOptions);

              return handler.resolve(response);
            } else {
              await clearAuthToken();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // =========================
  // 🔁 Queue System
  // =========================

  void _subscribeTokenRefresh(Function(String token) callback) {
    _subscribers.add(callback);
  }

  void _onRefreshed(String token) {
    for (var callback in _subscribers) {
      callback(token);
    }
    _subscribers.clear();
  }

  // =========================
  // 🔐 Token Management
  // =========================

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    _dio.options.headers.remove('Authorization');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // =========================
  // 🌐 API Methods
  // =========================

  Future<Response> get(String endpoint) async {
    await loadToken();
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    await loadToken();
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    await loadToken();
    return await _dio.delete(endpoint);
  }
}