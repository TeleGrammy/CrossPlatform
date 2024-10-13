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
