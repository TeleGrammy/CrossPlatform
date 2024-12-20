// Purpose:
// - To provide the actual logic for fetching book data and converting API responses into model objects.
// - Handles errors gracefully, returning either data or failure based on API response.
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
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
  Future<Either<String, void>> signInUser(Map<String, dynamic> userData) async {
    final result = await apiService.login(userData);

    return result.fold(
      (errorMessage) {
        return Left(errorMessage);
      },
      (_) {
        return const Right(null); // Successful registration
      },
    );
  }

  Future<Either<String, void>> signInWithGoogle() async {
    final result = await apiService
        .signInWithGoogle(); // No return value needed for success
    return result.fold(
      (errorMessage) {
        return Left(errorMessage);
      },
      (_) {
        return const Right(null); // Successful registration
      },
    );
  }

  Future<Either<String, void>> signInWithGitHub() async {
    final result = await apiService
        .signInWithGitHub(); // No return value needed for success
    return result.fold(
      (errorMessage) {
        return Left(errorMessage);
      },
      (_) {
        return const Right(null); // Successful registration
      },
    );
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
      return const Right(null); // Successful resend verification
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    try {
      await apiService.forgetPassword(email);
      return const Right(null); // Successful verification
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

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
  void logout() {
    apiService.logout();
  }
}
