
import 'package:meta/meta.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';


@immutable
abstract class RegisteredUsersState {}

final class RegisteredUsersLoading extends RegisteredUsersState {}

final class RegisteredUsersLoaded extends RegisteredUsersState {
  final List<RegisteredUsersData> registeredUsers;

  RegisteredUsersLoaded({required this.registeredUsers});
}

final class RegisteredUsersUpdating extends RegisteredUsersState {}

final class RegisteredUsersUpdated extends RegisteredUsersState {
  final bool isEnabled;

  RegisteredUsersUpdated({required this.isEnabled});
}

final class RegisteredUsersError extends RegisteredUsersState {
  final String message;

  RegisteredUsersError({required this.message});
}