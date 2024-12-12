class Participant {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String screenName;
  final String picture;
  final String status;
  final DateTime lastSeen;
  final DateTime joinedAt;

  Participant({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.screenName,
    required this.picture,
    required this.status,
    required this.lastSeen,
    required this.joinedAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['userId']['_id'],
      username: json['userId']['username'],
      email: json['userId']['email'],
      phone: json['userId']['phone'],
      screenName: json['userId']['screenName'],
      picture: json['userId']['picture'] ?? 'default.jpg',
      status: json['userId']['status'],
      lastSeen: DateTime.parse(json['userId']['lastSeen']),
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
