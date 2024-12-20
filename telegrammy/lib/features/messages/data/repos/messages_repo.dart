import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';

abstract class MessagesRepo {
  Future<Map<String,dynamic>> getChats({int page=1});
    Future<Map<String, dynamic>> getMessages({required String chatId});
   Future<Media>uploadMedia(audioPath);
}