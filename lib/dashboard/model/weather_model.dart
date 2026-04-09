class WeatherModel {
  final double avgTemperature;
  final double humidity;
  final double windSpeed;
  final String advisory;

  WeatherModel({
    required this.avgTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.advisory,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      avgTemperature: (json['currentTemperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      advisory: json['advisory'] ?? '',
    );
  }
}