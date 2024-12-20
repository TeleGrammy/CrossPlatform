part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsSuccess extends ContactsState {
  Map<String,dynamic> chats;

  ContactsSuccess({required this.chats});
}

class ContactsFailture extends ContactsState {}
