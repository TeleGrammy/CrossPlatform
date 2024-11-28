import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Message {
  final String id; // Unique ID
  final String text;
  final String time; // Formatted as a string (e.g., '10:00 AM')
  final bool isSentByUser; // Whether the message was sent by the user
  final Message? repliedTo; // The message being replied to, if any

  Message({
    String? id, // Optional ID, auto-generated if not provided
    required this.text,
    required this.time,
    required this.isSentByUser,
    this.repliedTo,
  }) : id = id ?? uuid.v4(); // Generate a unique ID if none is provided

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, text: "$text", time: "$time", isSentByUser: $isSentByUser, repliedTo: ${repliedTo?.id})';
  }
}

List<Message> messagess = [
  Message(
    text: 'Hey, how are you?',
    time: '10:00 AM',
    isSentByUser: true,
  ),
  Message(
    text: 'I\'m good, thanks! How about you?',
    time: '10:02 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'I\'m doing well! Just finished some work.',
    time: '10:05 AM',
    isSentByUser: true,
  ),
  Message(
    text: 'Sounds great! What are you up to later?',
    time: '10:08 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'Not much, just relaxing. Let\'s catch up soon.',
    time: '10:10 AM',
    isSentByUser: true,
  ),
  Message(
    text: 'Yeah, we should! Let me know when you\'re free.',
    time: '10:12 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'Yeah, we should! Let me know when you\'re free.',
    time: '10:12 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'Yeah, we should! Let me know when you\'re free.',
    time: '10:12 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'Yeah, we should! Let me know when you\'re free.',
    time: '10:12 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'Yeah, we should! Let me know when you\'re free.',
    time: '10:12 AM',
    isSentByUser: false,
  ),
  Message(
    text: 'For sure! Talk later.',
    time: '10:15 AM',
    isSentByUser: true,
    repliedTo: Message(
      text: 'Hey, how are you?',
      time: '10:00 AM',
      isSentByUser: true,
      id: '0f9cee3c-2e03-497b-b570-8ac5458438d7',
    ),
  ),
];

List<Message> messages = messagess.reversed.toList();
