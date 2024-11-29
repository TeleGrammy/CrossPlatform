class BlockedUsersResponse {
  final String status;
  final List<UserData> data;

  BlockedUsersResponse({required this.status, required this.data});

  factory BlockedUsersResponse.fromJson(Map<String, dynamic> json) {
    // print("Parsing BlockedUsersResponse: $json");

    final blockedUsers = (json['data']?['blockedUsers'] as List<dynamic>? ?? []);
    // print("Blocked Users: $blockedUsers");

    final userDataList = UserData.listFromJson(blockedUsers);
    // print("Final Parsed UserData List: $userDataList");

    return BlockedUsersResponse(
      status: json['status'] ?? "unknown",
      data: userDataList,
    );
  }
}

class UserData {
  final String userId;
  final String userName;

  UserData({required this.userId, required this.userName});

  factory UserData.fromJson(Map<String, dynamic> json) {
    // print("Parsing UserData: $json");
    return UserData(
      userId: json['userId'],
      userName: json['userName'],
    );
  }

  static List<UserData> listFromJson(List<dynamic> jsonList) {
    // print("Parsing List of UserData: $jsonList");
    return jsonList.map((json) {
      final userData = UserData.fromJson(json as Map<String, dynamic>);
      // print("Parsed UserData: ${userData.userId}, ${userData.userName}");
      return userData;
    }).toList();
  }

  @override
  String toString() => "UserData(userId: $userId, userName: $userName)";
}
