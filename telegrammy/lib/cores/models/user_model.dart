class UserModel {
  final String name;
  final String email;
  final String profilePhotoUrl;
  final String userType;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePhotoUrl,
    this.userType = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'userType': userType,
    };
  }
}