import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  Future<void> fetchMessages({required String chatId}) async {
    emit(MessagesLoading()); // Emit loading state

    try {
      final result = await getit
          .get<MessagesRepoImplementaion>()
          .getMessages(chatId: chatId);
      if (result.containsKey('error')) {
        emit(Messagesfailture(error: result['error'])); // Emit failure state
      } else {
        emit(MessagesSuccess(chatData: result)); // Emit success state with data
      }
    } catch (e) {
      emit(Messagesfailture(
          error: e.toString())); // Handle any unexpected errors
    }
  }
  
}
