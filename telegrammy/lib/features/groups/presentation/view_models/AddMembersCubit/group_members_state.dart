part of 'group_members_cubit.dart';

@immutable
abstract class GroupMembersState {}

final class GroupMembersInitial extends GroupMembersState {}

final class GroupMembersLoading extends GroupMembersState {}

final class GroupMembersLoaded extends GroupMembersState {
  final List<ContactData> contacts;
  GroupMembersLoaded({required this.contacts});
}

final class GroupMembersError extends GroupMembersState {
  final String errorMessage;
  GroupMembersError({required this.errorMessage});
}
