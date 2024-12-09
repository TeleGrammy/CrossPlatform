// class Message {
//   final String id;
//   final Sender sender;
//   final String messageType;
//   final Message? replyOn;
//   final bool? isForwarded;
//   final bool isEdited;
//   final List<String>? mentions;
//   final String status;
//   final String content;
//   final String? mediaUrl;
//   final String? mediaKey;
//   final DateTime timestamp;

//   Message({
//     required this.id,
//     required this.sender,
//     required this.messageType,
//     this.replyOn,
//     required this.isForwarded,
//     required this.isEdited,
//     required this.mentions,
//     required this.status,
//     required this.content,
//     required this.mediaUrl,
//     required this.mediaKey,
//     required this.timestamp,
//   });

//   // Factory constructor for creating a Message from JSON
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['_id'],
//       sender: Sender.fromJson(json['senderId']),
//       messageType: json['messageType'],
//       replyOn: json['replyOn'],
//       isForwarded: json['isForwarded'],
//       isEdited: json['isEdited'],
//       mentions: List<String>.from(json['mentions']),
//       status: json['status'],
//       content: json['content'],
//       mediaUrl: json['mediaUrl'],
//       mediaKey: json['mediaKey'],
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }

//   // Method to convert Message to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'senderId': sender.toJson(),
//       'messageType': messageType,
//       'replyOn': replyOn,
//       'isForwarded': isForwarded,
//       'isEdited': isEdited,
//       'mentions': mentions,
//       'status': status,
//       'content': content,
//       'mediaUrl': mediaUrl,
//       'mediaKey': mediaKey,
//       'timestamp': timestamp.toIso8601String(),
//     };
//   }
// }

// class Sender {
//   final String id;
//   final String username;

//   Sender({
//     required this.id,
//     required this.username,
//   });

//   // Factory constructor for creating a Sender from JSON
//   factory Sender.fromJson(Map<String, dynamic> json) {
//     return Sender(
//       id: json['_id'],
//       username: json['username'],
//     );
//   }

//   // Method to convert Sender to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'username': username,
//     };
//   }
// }
