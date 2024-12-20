part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupLoaded extends GroupState {
  final Group groupData;
  List<MemberData>? members;
  List<MemberData>? admins;
  List<ContactData>? contactsExcludingMembers;
  List<MemberData>? nonAdminMembers;
  GroupLoaded({
    required this.groupData,
    this.members,
    this.admins,
    this.contactsExcludingMembers,
    this.nonAdminMembers,
  });
}

final class GroupError extends GroupState {
  final String errorMessage;
  GroupError({required this.errorMessage});
}
