class Contact {
  final String id;
  final List<Participant> participants;
  final bool isGroup;
  final bool isChannel;
  final String createdAt;

  Contact({
    required this.id,
    required this.participants,
    required this.isGroup,
    required this.isChannel,
    required this.createdAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      isGroup: json['isGroup'],
      isChannel: json['isChannel'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((p) => p.toJson()).toList(),
      'isGroup': isGroup,
      'isChannel': isChannel,
      'createdAt': createdAt,
    };
  }
}

class Participant {
  final String id;
  final User user;
  final String joinedAt;
  final String draftMessage;

  Participant({
    required this.id,
    required this.user,
    required this.joinedAt,
    required this.draftMessage,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      user: User.fromJson(json['userId']),
      joinedAt: json['joinedAt'],
      draftMessage: json['draft_message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'joinedAt': joinedAt,
      'draft_message': draftMessage,
    };
  }
}

class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
    };
  }
}
