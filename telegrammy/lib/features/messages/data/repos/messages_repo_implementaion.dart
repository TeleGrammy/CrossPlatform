import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/messages_api_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo.dart';

class MessagesRepoImplementaion extends MessagesRepo {
  @override
  Future<List<Contact>> getChats({int page = 1}) async {
    return await getit.get<ApiService>().fetchChats();
  }

  @override
Future<Map<String, dynamic>> getMessages({required String chatId}) async {
  final result = await getit.get<MessagesApiService>().getMessages(chatId);
  return result.fold(
    (error) {
      // Handle the error case
      return {'error': error};
    },
    (data) {
      // Handle the success case
      return data;
    },
  );
}
}
