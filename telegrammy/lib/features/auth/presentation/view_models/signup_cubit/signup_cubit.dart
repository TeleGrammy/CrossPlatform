import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUpUser(Map<String, dynamic> userData) async {
    emit(SignUpLoading());
    final result = await getit.get<AuthRepoImplemention>().signUpUser(userData);
    result.fold((failre) {
      print('Cubit:error signing up user');
      emit(SignUpFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:user signed up successfully');
      emit(SignUpSuccess());
    });
  }

  Future<void> emailVerification(String email, String verificationCode) async {
    emit(VerificationLoading());
    if (verificationCode.length != 6) {
      emit(VerificationFailure(
          errorMessage: 'verification code should be 6 numbers'));
    } else {
      final result = await getit
          .get<AuthRepoImplemention>()
          .emailVerification(email, verificationCode);
      result.fold((failre) {
        print('Cubit:error verifying this email');
        emit(VerificationFailure(errorMessage: failre.errorMessage));
      }, (data) {
        print('Cubit:verified successfully');
        emit(VerificationSuccess());
      });
    }
  }

  Future<void> resendEmailVerification(String email) async {
    emit(VerificationLoading());
    final result =
        await getit.get<AuthRepoImplemention>().resendEmailVerification(email);
    result.fold((failre) {
      print('Cubit:error verifying this email');
      emit(VerificationFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:verified successfully');
      emit(VerificationSuccess());
    });
  }
}
