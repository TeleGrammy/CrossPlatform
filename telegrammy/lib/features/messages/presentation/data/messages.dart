// // class Message {
// //   final String id;
// //   final Sender sender;
// //   final String messageType;
// //   final Message? replyOn;
// //   final bool? isForwarded;
// //   final bool isEdited;
// //   final List<String>? mentions;
// //   final String status;
// //   final String content;
// //   final String? mediaUrl;
// //   final String? mediaKey;
// //   final DateTime timestamp;

// //   Message({
// //     required this.id,
// //     required this.sender,
// //     required this.messageType,
// //     this.replyOn,
// //     required this.isForwarded,
// //     required this.isEdited,
// //     required this.mentions,
// //     required this.status,
// //     required this.content,
// //     required this.mediaUrl,
// //     required this.mediaKey,
// //     required this.timestamp,
// //   });

// class Message {
//   final String id; // Unique ID
//   final String text;
//   final String time; // Formatted as a string (e.g., '10:00 AM')
//   final bool isSentByUser; // Whether the message was sent by the user
//   final String messageType;
//   final Message? repliedTo; // The message being replied to, if any
//   final String? audioUrl;
//   final String? attachmentKey;
//   final String? attachmentUrl;

//   Message({
//     String? id, // Optional ID, auto-generated if not provided
//     required this.messageType,
//     required this.text,
//     required this.time,
//     required this.isSentByUser,
//     this.audioUrl,
//     this.repliedTo,
//     this.attachmentKey,
//     this.attachmentUrl,
//   }) : id = id ?? id.v4(); // Generate a unique ID if none is provided

// // class Sender {
// //   final String id;
// //   final String username;

// //   Sender({
// //     required this.id,
// //     required this.username,
// //   });

// //   // Factory constructor for creating a Sender from JSON
// //   factory Sender.fromJson(Map<String, dynamic> json) {
// //     return Sender(
// //       id: json['_id'],
// //       username: json['username'],
// //     );
// //   }

// List<Message> messagess = [
//   Message(
//       text: 'Hey, how are you?',
//       time: '10:00 AM',
//       isSentByUser: true,
//       attachmentUrl:
//           "https://media.npr.org/assets/img/2023/12/12/gettyimages-1054147940-627235e01fb63b4644bec84204c259f0a343e35b.jpg?s=1100&c=85&f=jpeg",
//       messageType: 'image'),
//   Message(
//       text: 'Hey, how are you?',
//       time: '10:00 AM',
//       isSentByUser: true,
//       attachmentUrl:
//           "https://v.ftcdn.net/03/96/08/89/700_F_396088921_baVpC09PbCcvLnHoNv8NfYLrJH9lG7Eh_ST.mp4",
//       messageType: 'video'),
//   Message(
//       text: 'wlkfwfj',
//       time: '10:00 AM',
//       isSentByUser: true,
//       attachmentUrl:
//           'https://www.videvo.net/sound-effect/tone-whistle-wobble-a/446174/#rs=audio-titlee',
//       messageType: 'audio'),
//   Message(
//       text: 'fjwnf',
//       time: '10:00 AM',
//       isSentByUser: true,
//       attachmentUrl: 'https://www.google.com',
//       messageType: 'file'),
//   Message(
//     text: 'I\'m good, thanks! How about you?',
//     time: '10:02 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'I\'m doing well! Just finished some work.',
//     time: '10:05 AM',
//     isSentByUser: true,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Sounds great! What are you up to later?',
//     time: '10:08 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Not much, just relaxing. Let\'s catch up soon.',
//     time: '10:10 AM',
//     isSentByUser: true,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Yeah, we should! Let me know when you\'re free.',
//     time: '10:12 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Yeah, we should! Let me know when you\'re free.',
//     time: '10:12 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Yeah, we should! Let me know when you\'re free.',
//     time: '10:12 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Yeah, we should! Let me know when you\'re free.',
//     time: '10:12 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'Yeah, we should! Let me know when you\'re free.',
//     time: '10:12 AM',
//     isSentByUser: false,
//     messageType: 'text',
//   ),
//   Message(
//     text: 'For sure! Talk later.',
//     time: '10:15 AM',
//     isSentByUser: true,
//     repliedTo: Message(
//       text: 'Hey, how are you?',
//       time: '10:00 AM',
//       isSentByUser: true,
//       id: '0f9cee3c-2e03-497b-b570-8ac5458438d7',
//       messageType: 'text',
//     ),
//     messageType: 'text',
//   ),
// ];

// List<Message> messages = messagess.reversed.toList();