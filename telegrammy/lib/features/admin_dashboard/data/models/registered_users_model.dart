class RegisteredUsersResponse {
  final String status;
  final List<RegisteredUsersData> data;

  RegisteredUsersResponse({
    required this.status,
    required this.data,
  });

  // Factory method to create ApiResponse from JSON
  factory RegisteredUsersResponse.fromJson(Map<String, dynamic> json) {
    return RegisteredUsersResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => RegisteredUsersData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert ApiResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class RegisteredUsersData {
  final String id;
  final String username;
  final String screenName;
  final String email;
  final String phone;
  final String picture;
  final String bio;
  final String status;
  bool isBanned; // Mutable property

  RegisteredUsersData({
    required this.id,
    required this.username,
    required this.screenName,
    required this.email,
    required this.phone,
    required this.picture,
    required this.bio,
    required this.status,
    required this.isBanned,
  });

  // Factory method to create UserData from JSON
  factory RegisteredUsersData.fromJson(Map<String, dynamic> json) {
    return RegisteredUsersData(
      id: json['id'] as String,
      username: json['username'] as String,
      screenName: json['screenName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      picture: json['picture'] as String,
      bio: json['bio'] as String,
      status: json['status'] as String,
      isBanned: json['isBanned'] as bool,
    );
  }

  // Method to convert UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'screenName': screenName,
      'email': email,
      'phone': phone,
      'picture': picture,
      'bio': bio,
      'status': status,
      'isBanned': isBanned,
    };
  }
}
