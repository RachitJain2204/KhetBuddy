class YieldResponse {
  final String season;
  final Location location;
  final Soil soil;
  final String cropType;
  final YieldPerHectare yieldPerHectare;
  final String confidenceNote;

  YieldResponse({
    required this.season,
    required this.location,
    required this.soil,
    required this.cropType,
    required this.yieldPerHectare,
    required this.confidenceNote,
  });

  factory YieldResponse.fromJson(Map<String, dynamic> json) {
    return YieldResponse(
      season: json['season'],
      location: Location.fromJson(json['location']),
      soil: Soil.fromJson(json['soil']),
      cropType: json['crop_type'],
      yieldPerHectare:
      YieldPerHectare.fromJson(json['yield_per_hectare']),
      confidenceNote: json['confidence_note'],
    );
  }
}

class Location {
  final String district;
  final String state;
  final double latitude;
  final double longitude;

  Location({
    required this.district,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      district: json['district'],
      state: json['state'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class Soil {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double soilPh;
  final double moisture;

  Soil({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.soilPh,
    required this.moisture,
  });

  factory Soil.fromJson(Map<String, dynamic> json) {
    return Soil(
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      soilPh: (json['soil_ph'] as num).toDouble(),
      moisture: (json['soil_moisture'] as num).toDouble(),
    );
  }
}

class YieldPerHectare {
  final double lower;
  final double expected;
  final double higher;

  YieldPerHectare({
    required this.lower,
    required this.expected,
    required this.higher,
  });

  factory YieldPerHectare.fromJson(Map<String, dynamic> json) {
    return YieldPerHectare(
      lower: (json['lower'] as num).toDouble(),
      expected: (json['expected'] as num).toDouble(),
      higher: (json['higher'] as num).toDouble(),
    );
  }
}