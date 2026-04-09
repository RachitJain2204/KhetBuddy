class WeatherModel {
  final double avgTemperature;
  final double humidity;
  final double rainfallToday;
  final double totalRainfall;
  final double windSpeed;
  final String advisory;

  WeatherModel({
    required this.avgTemperature,
    required this.humidity,
    required this.rainfallToday,
    required this.totalRainfall,
    required this.windSpeed,
    required this.advisory,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      avgTemperature: (json['avgTemperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      rainfallToday: (json['rainfallToday'] ?? 0).toDouble(),
      totalRainfall: (json['totalRainfall'] ?? 0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      advisory: json['advisory'] ?? '',
    );
  }
}