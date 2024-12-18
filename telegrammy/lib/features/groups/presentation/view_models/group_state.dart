part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupLoaded extends GroupState {
  final Group groupData;
  GroupLoaded({required this.groupData});
}

final class GroupError extends GroupState {
  final String errorMessage;
  GroupError({required this.errorMessage});
}
