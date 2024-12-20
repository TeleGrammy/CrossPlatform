import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesRepoImplementaion messagesRepo = MessagesRepoImplementaion();

  MessagesCubit() : super(MessagesInitial());

  void getChatData() {}

  Future<dynamic> uploadMedia(dynamic mediaFile) async {
    dynamic fileData;
    var result = await messagesRepo.uploadMedia(mediaFile);
    result.fold((failre) {
      print('Cubit:error sending media file ${failre.errorMessage}');
      emit(Messagesfailture(error: failre.errorMessage));
    }, (data) {
      fileData = data;
    });
    return fileData;
  }

  Future<Media> uploadAudio(String filePath) async {
    dynamic audioData;
    var result = await messagesRepo.uploadAudio(filePath);
    result.fold((failre) {
      print('Cubit:error sending media file ${failre.errorMessage}');
      emit(Messagesfailture(error: failre.errorMessage));
    }, (data) {
      audioData = data;
    });
    return audioData;
  }

  Future<void> fetchMessages({required String chatId}) async {
    emit(MessagesLoading()); // Emit loading state

    try {
      final result = await getit
          .get<MessagesRepoImplementaion>()
          .getMessages(chatId: chatId);
      print(result);
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
