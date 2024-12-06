import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  Future<void> getContacts() async {
    emit(ContactsLoading());

    try {
      final chats =
          await getit.get<MessagesRepoImplementaion>().getChats();
      emit(ContactsSuccess(chats: chats));
    } catch (error) {
      emit(ContactsFailture());
    }
  }
}
