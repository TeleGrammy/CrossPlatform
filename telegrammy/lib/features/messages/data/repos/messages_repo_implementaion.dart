import 'package:telegrammy/cores/services/api_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo.dart';

class MessagesRepoImplementaion extends MessagesRepo{
  @override
  Future<List<Contact>> getContacts({int page = 1}) async{
    return await getit.get<ApiService>().fetchChats();
  }
}