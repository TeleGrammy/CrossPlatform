import 'dart:convert';

class Chat {
  final String id;
  final String name;
  final String? photo;
  final LastMessage? lastMessage;
  final String draftMessage;
  final bool isChannel;
  final bool isGroup;
  final List<Participant> participants;
  final String? pinnedMessages;
  final String? createdAt;
  final String? channelId;
  final String? groupId;

  Chat({
    required this.id,
    required this.name,
    this.photo,
    this.lastMessage,
    required this.draftMessage,
    required this.isChannel,
    this.pinnedMessages,
    required this.participants,
    required this.isGroup,
    this.createdAt,
    this.channelId,
    this.groupId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      photo: (json['photo']) ?? 'default.jpg',
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
      draftMessage: json['draftMessage'] == null ? '' : json['draftMessage'],
      createdAt: json['createdAt'],
      isChannel: json['isChannel'] ?? false,
      isGroup: json['isGroup'] ?? false,
      participants: json['participants'] ?? [],
      channelId: (json['isChannel'] == true) ? json['channelId'] : null,
      groupId: (json['isGroup'] == true) ? json['groupId'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'lastMessage': lastMessage?.toJson(),
      'draftMessage': draftMessage,
      'isChannel': isChannel,
    };
  }
}

class LastMessage {
  final String id;
  final Sender senderId;
  final String messageType;
  final String status;
  final String content;
  final String? mediaUrl;
  final DateTime timestamp;

  LastMessage({
    required this.id,
    required this.senderId,
    required this.messageType,
    required this.status,
    required this.content,
    required this.mediaUrl,
    required this.timestamp,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'],
      senderId: Sender.fromJson(json['senderId']),
      messageType: json['messageType'],
      status: json['status'],
      content: json['content'],
      mediaUrl: json['mediaUrl'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId.toJson(),
      'messageType': messageType,
      'status': status,
      'content': content,
      'mediaUrl': mediaUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class Sender {
  final String id;
  final String username;

  Sender({
    required this.id,
    required this.username,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
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

class Participant {
  final String id;
  final User user;
  final String joinedAt;
  final String draftMessage;
  final String role;

  Participant({
    required this.id,
    required this.user,
    required this.joinedAt,
    required this.draftMessage,
    required this.role,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      user: User.fromJson(json['userId']),
      joinedAt: json['joinedAt'],
      draftMessage: json['draft_message'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'joinedAt': joinedAt,
      'draft_message': draftMessage,
      'role': role
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
