class ProfileVisibility {
  String profilePicture;
  String stories;
  String lastSeen;

  ProfileVisibility({
    required this.profilePicture,
    required this.stories,
    required this.lastSeen,
  });

  Map<String, String> toJson() {
    return {
      'profilePicture': profilePicture,
      'stories': stories,
      'lastSeen': lastSeen,
    };
  }

  factory ProfileVisibility.fromJson(Map<String, dynamic> json) {
    return ProfileVisibility(
      profilePicture: json['profilePicture'],
      stories: json['stories'],
      lastSeen: json['lastSeen'],
    );
  }
}
