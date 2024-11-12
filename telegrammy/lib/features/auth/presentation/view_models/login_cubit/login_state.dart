part of 'login_cubit.dart';

@immutable
class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSucess extends LoginState {}

final class LoginError extends LoginState {
  final String message;
  LoginError({required this.message});
}
