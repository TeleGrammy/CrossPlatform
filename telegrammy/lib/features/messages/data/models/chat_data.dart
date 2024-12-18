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
  final List<Participantt> participants;
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
          .map((participant) => Participantt.fromJson(participant))
          .toList(),
      isGroup: json['isGroup'],
      isChannel: json['isChannel'],
      createdAt: json['createdAt'],
      pinnedMessages: json['pinnedMessages'] ?? [],
    );
  }
}

class Participantt {
  final User user;
  final String joinedAt;
  final String draftMessage;

  Participantt({
    required this.user,
    required this.joinedAt,
    required this.draftMessage,
  });

  factory Participantt.fromJson(Map<String, dynamic> json) {
    return Participantt(
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
  final String sender;
  final String messageType;
  final List<Mention>? mentions;
  String content;
  final String timestamp;
  final Message? replyOn; // Nullable to handle null values
  final bool isForwarded;
  final bool isEdited;
  final String status;
  String? mediaUrl;
  String? mediaKey;

  Message({
    required this.id,
    required this.sender,
    required this.messageType,
    required this.mentions,
    required this.content,
    required this.timestamp,
    this.replyOn,
    required this.isForwarded,
    required this.isEdited,
    required this.status,
    this.mediaUrl,
    this.mediaKey,
  });
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': sender,
      'messageType': messageType,
      'mentions': mentions?.map((mention) => mention.toJson()).toList(),
      'content': content,
      'timestamp': timestamp,
      'replyOn': replyOn?.toJson(), // Convert nested message to JSON
      'isForwarded': isForwarded,
      'isEdited': isEdited,
      'status': status,
      'mediaUrl': mediaUrl,
      'mediaKey': mediaKey,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sender: json['senderId'] is Map<String, dynamic>
          ? json['senderId']['_id']
          : json['senderId'],
      messageType: json['messageType'],
      mentions: (json['mentions'] as List)
          .map((mention) => Mention.fromJson(mention))
          .toList(),
      content: json['content'],
      timestamp: json['timestamp'],
      replyOn: json['replyOn'] != null
          ? Message.fromJson(json['replyOn'])
          : null, // May be null
      isForwarded: json['isForwarded'],
      isEdited: json['isEdited'],
      status: json['status'],
      mediaUrl: json['mediaUrl'],
      mediaKey: json['mediaKey'],
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
    };
  }
}
