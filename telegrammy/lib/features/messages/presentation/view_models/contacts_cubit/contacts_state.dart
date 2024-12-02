part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsSuccess extends ContactsState {
  List<Contact> contacts;

  ContactsSuccess({required this.contacts});
}

class ContactsFailture extends ContactsState {}
