import 'package:telegrammy/features/messages/data/models/contacts.dart';

abstract class MessagesRepo {
  Future<List<Contact>> getChats({int page=1});
    Future<Map<String, dynamic>> getMessages({required String chatId});
}