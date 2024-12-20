import 'package:meta/meta.dart';

import 'package:telegrammy/features/admin_dashboard/data/models/groups_dashboard_model.dart';

@immutable
abstract class RegisteredGroupsState {}

final class RegisteredGroupsLoading extends RegisteredGroupsState {}

final class RegisteredGroupsLoaded extends RegisteredGroupsState {
  final List<GroupData> registeredGroups;

  RegisteredGroupsLoaded({required this.registeredGroups});
}

final class RegisteredGroupsUpdating extends RegisteredGroupsState {}

final class RegisteredGroupsUpdated extends RegisteredGroupsState {
  final bool isEnabled;

  RegisteredGroupsUpdated({required this.isEnabled});
}



final class RegisteredGroupsError extends RegisteredGroupsState {
  final String message;

  RegisteredGroupsError({required this.message});
}
