class RegisteredUsersResponse {
  final String status;
  final List<RegisteredUsersData> data;

  RegisteredUsersResponse({
    required this.status,
    required this.data,
  });

  // Factory method to create RegisteredUsersResponse from JSON
  factory RegisteredUsersResponse.fromJson(Map<String, dynamic> json) {
   
    return RegisteredUsersResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => RegisteredUsersData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // // Method to convert RegisteredUsersResponse to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'status': status,
  //     'data': data.map((item) => item.toJson()).toList(),
  //   };
  // }
}

class RegisteredUsersData {
  final String id;
  final String username;
  final String? screenName; // Nullable
  final String email;
  final String? phone;
  final String? picture; // Nullable
  final String? bio; // Nullable
  final String status;
  final String? pictureKey; // Nullable

  RegisteredUsersData({
    required this.id,
    required this.username,
    this.screenName,
    required this.email,
    this.phone,
    this.picture,
    this.bio,
    required this.status,
    this.pictureKey,
  });

  // Factory method to create RegisteredUsersData from JSON
  factory RegisteredUsersData.fromJson(Map<String, dynamic> json) {
    // print('success ${json['pictureKey']} ${json['username']}');
    return RegisteredUsersData(
      id: json['_id'] as String,
      username: json['username'] as String,
      screenName: json['screenName'] as String?, // Safely handle nullable field
      email: json['email'] as String,
      phone: json['phone'] as String?,
      picture: json['picture']?.isNotEmpty == true ? json['picture'] as String : null, // Handle empty strings
      bio: json['bio'] as String?, // Nullable
      status: json['status'] as String,
      pictureKey: json['pictureKey'] as String?, // Nullable
    );
  }
}

