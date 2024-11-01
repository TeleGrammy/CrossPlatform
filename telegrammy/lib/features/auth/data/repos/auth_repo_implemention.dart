// Purpose:
// - To provide the actual logic for fetching book data and converting API responses into model objects.
// - Handles errors gracefully, returning either data or failure based on API response.
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/api_service.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo.dart';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/models/user_model.dart';
import 'package:telegrammy/cores/services/api_service.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo.dart';

class AuthRepoImplemention extends AuthRepo {
  final ApiService apiService;
  AuthRepoImplemention({required this.apiService});

  @override
  Future<Either<Failure, void>> signUpUser(
      Map<String, dynamic> userData) async {
    try {
      await apiService.signUpUser(userData);
      return const Right(null); // Successful registration
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signInUser(
      Map<String, dynamic> userData) async {
    try {
      await apiService.login(userData);
      return const Right(null); // Successful registration
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      await apiService.signInWithGoogle(); // No return value needed for success
      return const Right(null); // Right with void (no value)
    } catch (error) {
      return Left(
          ServerError(errorMessage: 'Sign-in error: $error')); // Error message
    }
  }

  Future<Either<Failure, void>> signInWithFacebook() async {
    try {
      await apiService
          .signInWithFacebook(); // No return value needed for success
      return const Right(null); // Right with void (no value)
    } catch (error) {
      return Left(
          ServerError(errorMessage: 'Sign-in error: $error')); // Error message
    }
  }

  Future<Either<Failure, void>> signInWithGitHub() async {
    try {
      await apiService.signInWithGitHub(); // No return value needed for success
      return const Right(null); // Right with void (no value)
    } catch (error) {
      return Left(
          ServerError(errorMessage: 'Sign-in error: $error')); // Error message
    }
  }

  @override
  Future<Either<Failure, void>> emailVerification(
      String email, String verificationCode) async {
    try {
      await apiService.emailVerification(email, verificationCode);
      return const Right(null); // Successful verification
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification(String email) async {
    try {
      await apiService.resendEmailVerification(email);
      return const Right(null); // Successful verification
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> forgetPassword(String email) async {
  //   try {
  //     await apiService.resendEmailVerification(email);
  //     return const Right(null); // Successful verification
  //   } catch (error) {
  //     return Left(ServerError(errorMessage: error.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> resetPassword(
  //     String password, String newPassword) async {
  //   try {
  //     await apiService.resendEmailVerification(email);
  //     return const Right(null); // Successful verification
  //   } catch (error) {
  //     return Left(ServerError(errorMessage: error.toString()));
  //   }
  // }
}
