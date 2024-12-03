class ProfileVisibility {
  final String profilePicture;
  final String stories;
  final String lastSeen;

  ProfileVisibility({
    required this.profilePicture,
    required this.stories,
    required this.lastSeen,
  });

  // Convert the model to JSON format
  Map<String, dynamic> toJson() {
    return {
      'profilePicture': profilePicture,
      'stories': stories,
      'lastSeen': lastSeen,
    };
  }
}
