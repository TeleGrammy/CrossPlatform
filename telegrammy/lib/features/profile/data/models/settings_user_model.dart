class UserPrivacySettingsResponse {
  final String status;
  final UserPrivacySettings data;

  UserPrivacySettingsResponse({required this.status, required this.data});

  factory UserPrivacySettingsResponse.fromJson(Map<String, dynamic> json) {
    final privacySettings = json['data']?['userPrivacySettings'] as Map<String, dynamic>?;

    return UserPrivacySettingsResponse(
      status: json['status'] ?? "unknown", // Default value for status if not present
      data: UserPrivacySettings.fromJson(privacySettings ?? {}),
    );
  }
}

class UserPrivacySettings {
  final String profilePictureVisibility;
  final String storiesVisibility;
  final String lastSeenVisibility;
  final bool readReceipts; // Boolean value
  final String whoCanAddMe;

  UserPrivacySettings({
    required this.profilePictureVisibility,
    required this.storiesVisibility,
    required this.lastSeenVisibility,
    required this.readReceipts,
    required this.whoCanAddMe,
  });

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) {
    return UserPrivacySettings(
      profilePictureVisibility: json['profilePictureVisibility'] ?? "unknown",
      storiesVisibility: json['storiesVisibility'] ?? "unknown",
      lastSeenVisibility: json['lastSeenVisibility'] ?? "unknown",
      readReceipts: json['readReceipts'] ?? false, // Ensure default boolean value if not present
      whoCanAddMe: json['whoCanAddMe'] ?? "unknown",
    );
  }

  @override
  String toString() {
    return "UserPrivacySettings("
        "profilePictureVisibility: $profilePictureVisibility, "
        "storiesVisibility: $storiesVisibility, "
        "lastSeenVisibility: $lastSeenVisibility, "
        "readReceipts: $readReceipts, "
        "whoCanAddMe: $whoCanAddMe)";
  }
}
