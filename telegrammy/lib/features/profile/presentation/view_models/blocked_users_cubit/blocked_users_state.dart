import 'package:meta/meta.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';

@immutable
abstract class BlockedUsersState {}

final class BlockedUsersInitial extends BlockedUsersState {}

final class BlockedUsersLoading extends BlockedUsersState {}

final class BlockedUsersLoaded extends BlockedUsersState {
  final List<UserData> blockedUsers;

  BlockedUsersLoaded({required this.blockedUsers});
}

final class BlockedUsersUpdating extends BlockedUsersState {}

final class BlockedUsersUpdated extends BlockedUsersState {
  final List<UserData> blockedUsers;

  BlockedUsersUpdated({required this.blockedUsers});
}

// final class BlockedUsersBlockAction extends BlockedUsersState {}

final class BlockedUsersUnblockAction extends BlockedUsersState {}

final class BlockedUsersError extends BlockedUsersState {
  final String message;

  BlockedUsersError({required this.message});
}



@immutable
abstract class ContactstoState {}

final class ContactsInitial extends ContactstoState {}

final class ContactsLoading extends ContactstoState {}

class ContactsLoaded extends ContactstoState {
  final List<ContactData> contacts;

  ContactsLoaded({required this.contacts});
}

final class BlockedUsersBlockAction extends ContactstoState {}

final class ContactsError extends ContactstoState {
  final String message;

  ContactsError({required this.message});
}
