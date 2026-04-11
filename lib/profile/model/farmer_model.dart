class FarmerModel {
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String email;
  final String profileImage;

  FarmerModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.email,
    required this.profileImage,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    return FarmerModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNo": phoneNo,
    };
  }

  FarmerModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNo,
    String? email,
    String? profileImage,
  }) {
    return FarmerModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}