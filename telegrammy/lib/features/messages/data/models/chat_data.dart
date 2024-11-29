import 'package:meta/meta.dart';

class ChatData {
  final Chat chat;
  final Messages messages;

  ChatData({required this.chat, required this.messages});

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chat: Chat.fromJson(json['chat']),
      messages: Messages.fromJson(json['messages']),
    );
  }
}

class Chat {
  final String id;
  final List<Participant> participants;
  final bool isGroup;
  final bool isChannel;
  final String createdAt;
  final List<dynamic> pinnedMessages;

  Chat({
    required this.id,
    required this.participants,
    required this.isGroup,
    required this.isChannel,
    required this.createdAt,
    required this.pinnedMessages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      isGroup: json['isGroup'],
      isChannel: json['isChannel'],
      createdAt: json['createdAt'],
      pinnedMessages: json['pinnedMessages'] ?? [],
    );
  }
}

class Participant {
  final User user;
  final String joinedAt;
  final String draftMessage;

  Participant({
    required this.user,
    required this.joinedAt,
    required this.draftMessage,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      user: User.fromJson(json['userId']),
      joinedAt: json['joinedAt'],
      draftMessage: json['draft_message'],
    );
  }
}

class User {
  final String id;
  final String username;
  final String? screenName;
  final String? picture;
  final String email;
  final String phone;
  final String status;
  final String lastSeen;

  User({
    required this.id,
    required this.username,
    this.screenName,
    this.picture,
    required this.email,
    required this.phone,
    required this.status,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      screenName: json['screenName'],
      picture: json['picture'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      lastSeen: json['lastSeen'],
    );
  }
}

class Messages {
  final int totalMessages;
  final int currentPage;
  final int totalPages;
  final List<Message> data;

  Messages({
    required this.totalMessages,
    required this.currentPage,
    required this.totalPages,
    required this.data,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      totalMessages: json['totalMessages'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      data: (json['data'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }
}

class Message {
  final String id;
  final Sender sender;
  final String messageType;
  final List<Mention> mentions;
  final String content;
  final String timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.messageType,
    required this.mentions,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sender: Sender.fromJson(json['senderId']),
      messageType: json['messageType'],
      mentions: (json['mentions'] as List)
          .map((mention) => Mention.fromJson(mention))
          .toList(),
      content: json['content'],
      timestamp: json['timestamp'],
    );
  }
}

class Sender {
  final String id;
  final String username;

  Sender({required this.id, required this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'],
      username: json['username'],
    );
  }
}

class Mention {
  final String id;
  final String username;

  Mention({required this.id, required this.username});

  factory Mention.fromJson(Map<String, dynamic> json) {
    return Mention(
      id: json['_id'],
      username: json['username'],
    );
  }
}
