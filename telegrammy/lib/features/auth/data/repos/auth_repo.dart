// Purpose:
// - To serve as a contract for any repository implementation.
// - Ensures that the concrete repository provides the required data operations.

// example
// import 'package:bookly_app/Cores/errors/erorrs.dart';
// import 'package:bookly_app/Features/home/data/models/bookmodel/bookmodel.dart';
// import 'package:dartz/dartz.dart';

// abstract class HomeRepo {
//   Future<Either<Failure, List<Bookmodel>>> fetchFeaturedBooks();
//   Future<Either<Failure, List<Bookmodel>>> fetchBestSellerBooks();
// }

import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';

abstract class AuthRepo {
  Future<Either<String, void>> signInWithGoogle();
  Future<Either<String, void>> signInWithGitHub();
  Future<Either<String, void>> signInUser(Map<String, dynamic> userData);
  Future<Either<Failure, void>> signUpUser(Map<String, dynamic> userData);
  Future<Either<Failure, void>> emailVerification(
      String email, String verificationCode);
  Future<Either<Failure, void>> resendEmailVerification(String email);
  Future<Either<Failure, void>> forgetPassword(String email);
    void logout();
  // Future<Either<Failure, void>> resetPassword(
  //     String password, String newPassword);
}
