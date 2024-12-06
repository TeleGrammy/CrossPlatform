part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsSuccess extends ContactsState {
  List<Contact> chats;

  ContactsSuccess({required this.chats});
}

class ContactsFailture extends ContactsState {}
