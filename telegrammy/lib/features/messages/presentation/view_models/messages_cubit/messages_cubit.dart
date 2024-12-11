import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesRepoImplementaion messagesRepo = MessagesRepoImplementaion();

  MessagesCubit() : super(MessagesInitial());

  void getChatData() {}

  Future<dynamic> sendMedia(XFile mediaFile) async {
    dynamic fileData;
    emit(MessagesLoading());
    var result = await messagesRepo.sendMedia(mediaFile);
    result.fold((failre) {
      print('Cubit:error sending media file');
      emit(Messagesfailture(errorMessage: failre.errorMessage));
    }, (data) {
      emit(SendingMediaSuccess(mediaUrl: data));
      fileData = data;
    });
    return fileData;
  }

  Future<dynamic> sendAudio(String filePath) async {
    dynamic audioData;
    emit(MessagesLoading());
    var result = await messagesRepo.sendAudio(filePath);
    result.fold((failre) {
      print('Cubit:error sending media file');
      emit(Messagesfailture(errorMessage: failre.errorMessage));
    }, (data) {
      emit(SendingMediaSuccess(mediaUrl: data));
      audioData = data;
    });
    return audioData;
  }
}
