class ProfileInfo {
  String? email;
  String? username;
  String? screenName;
  String? bio;
  String? phoneNumber;
  String? status;
  DateTime? lastSeen;
  String? profilePic;

  ProfileInfo({
    this.email,
    this.username,
    this.screenName,
    this.bio,
    this.phoneNumber,
    this.status,
    this.lastSeen,
    this.profilePic,
  });

  Map<String, String> toJson() {
    Map<String, String> json = {};

    if (email != null) json['email'] = email!;
    if (username != null) json['username'] = username!;
    if (screenName != null) json['screenName'] = screenName!;
    if (bio != null) json['bio'] = bio!;
    if (phoneNumber != null) json['phone'] = phoneNumber!;
    if (status != null) json['status'] = status!;
    if (lastSeen != null) json['lastSeen'] = lastSeen.toString();
    if (profilePic != null) json['picture'] = profilePic!;
    print(json);
    return json;
  }

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      email: json['email'],
      username: json['username'],
      screenName: json['screenName'],
      bio: json['bio'],
      phoneNumber: json['phone'],
      status: json['status'],
      //lastSeen: DateTime.parse(json['lastSeen']),
      profilePic: json['picture'],
    );
  }
}

class ProfileInfoResponse {
  final String status;
  final ProfileInfo data;

  ProfileInfoResponse({required this.status, required this.data});

  factory ProfileInfoResponse.fromJson(Map<String, dynamic> json) {
    return ProfileInfoResponse(
      status: json['status'],
      data: ProfileInfo.fromJson(json['data']['user']),
    );
  }
}

class ProfilePictureResponse {
  final String status;
  final String imageUrl;

  ProfilePictureResponse({required this.status, required this.imageUrl});

  factory ProfilePictureResponse.fromJSON(Map<String, dynamic> json) {
    return ProfilePictureResponse(
      status: json['status'],
      imageUrl: json['data']['user']['picture'],
    );
  }
}
