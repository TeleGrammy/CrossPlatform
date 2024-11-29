import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  void getChatData(){
    
  }
}
