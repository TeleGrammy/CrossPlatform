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
import 'package:telegrammy/cores/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> signInWithGoogle();
  Future<Either<Failure, void>> signInWithFacebook();
  Future<Either<Failure, void>> signInWithGitHub();
  Future<Either<Failure, void>> signUpUser(Map<String, dynamic> userData);
  Future<Either<Failure, void>> emailVerification(
      String email, String verificationCode);
  Future<Either<Failure, void>> resendEmailVerification(String email);
}
