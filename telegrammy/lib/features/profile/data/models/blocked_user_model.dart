class BlockedUsersResponse {
  final String status;
  final List<UserData> data;

  BlockedUsersResponse({required this.status, required this.data});

  // Factory constructor to create an instance from JSON
  factory BlockedUsersResponse.fromJson(Map<String, dynamic> json) {
    return BlockedUsersResponse(
      status: json['status'],
      data: List<UserData>.from(json['data'].map((item) => UserData.fromJson(item))),
    );
  }
}

class UserData {
  final String userId;
  final String username;

  UserData({required this.userId, required this.username});

  // Factory constructor to create an instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      username: json['username'],
    );
  }
}
class UserActionRequest {
  final String userId;

  UserActionRequest({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}
