part of 'contacts_cubit.dart';

@immutable
sealed class ContactsState {}

final class ContactsInitial extends ContactsState {}

final class ContactsLoading extends ContactsState {}

final class ContactsSuccess extends ContactsState {
  final List<Contact> contacts;

  ContactsSuccess({required this.contacts});
}

final class ContactsFailture extends ContactsState {}
