import 'package:telegrammy/features/messages/data/models/contacts.dart';

abstract class MessagesRepo {
  Future<List<Contact>> getContacts({int page=1});
}