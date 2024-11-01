part of 'signup_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpFailure extends SignUpState {
  final String errorMessage;
  SignUpFailure({required this.errorMessage});
}

final class SignUpSuccess extends SignUpState {}

final class VerificationLoading extends SignUpState {}

final class VerificationSuccess extends SignUpState {}

final class VerificationFailure extends SignUpState {
  final String errorMessage;
  VerificationFailure({required this.errorMessage});
}
