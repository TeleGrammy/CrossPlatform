// Purpose:
// - To provide the actual logic for fetching book data and converting API responses into model objects.
// - Handles errors gracefully, returning either data or failure based on API response.

// example

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
      await apiService.signInWithFacebook(); // No return value needed for success
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
}


// class HomeRepoImplementation extends HomeRepo {
//   final ApiService apiService;
//   HomeRepoImplementation({required this.apiService});
//   @override
//   Future<Either<Failure, List<Bookmodel>>> fetchBestSellerBooks() async {
//     try {
//       var data = await apiService.get(
//           endpoint:
//               'volumes?q=performance&sorting=newest&filtering=free-ebooks');

//       // Ensure 'items' is a List and not null
//       if (data['items'] != null && data['items'] is List) {
//         List<Bookmodel> books = [];

//         // Cast 'data['items']' to List
//         for (var item in data['items'] as List) {
//           books.add(Bookmodel.fromJson(item));
//         }
//         return Right(books);
//       } else {
//         return const Right([]); // Return an empty list if 'items' is null
//       }
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerError.fromDioError(e));
//       }
//       return Left(ServerError(errorMessage: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Bookmodel>>> fetchFeaturedBooks() async {
//     try {
//       var data = await apiService.get(
//           endpoint: 'volumes?q=performance&filtering=free-ebooks');

//       // Ensure 'items' is a List and not null
//       if (data['items'] != null && data['items'] is List) {
//         List<Bookmodel> books = [];

//         // Cast 'data['items']' to List
//         for (var item in data['items'] as List) {
//           books.add(Bookmodel.fromJson(item));
//         }
//         return Right(books);
//       } else {
//         return const Right([]); // Return an empty list if 'items' is null
//       }
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerError.fromDioError(e));
//       }
//       return Left(ServerError(errorMessage: e.toString()));
//     }
//   }
// }
