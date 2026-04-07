class ProfileModel {
  final String firstName;
  final String lastName;
  final String phoneNo;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNo": phoneNo,
    };
  }
}