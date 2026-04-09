class Farmer {
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String profileImage;
  final String email;

  Farmer({
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.profileImage,
    required this.email,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNo: json['phoneNo'],
      profileImage: json['profileImage'],
      email: json['email'],
    );
  }

  String get fullName => "$firstName $lastName";
}