class FarmModel {
  final int id;
  final String crop;
  final String irrigationType;
  final double latitude;
  final double longitude;
  final double phLevel;
  final double totalLand;
  final String district;

  FarmModel({
    required this.id,
    required this.crop,
    required this.irrigationType,
    required this.latitude,
    required this.longitude,
    required this.phLevel,
    required this.totalLand,
    required this.district,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'] ?? 0,
      crop: json['crop'] ?? '',
      irrigationType: json['irrigationType'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      phLevel: (json['phLevel'] ?? 0).toDouble(),
      totalLand: (json['totalLand'] ?? 0).toDouble(),
      district: json['district'] ?? '',
    );
  }
}