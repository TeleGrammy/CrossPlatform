// Purpose:
// - To provide the actual logic for fetching book data and converting API responses into model objects.
// - Handles errors gracefully, returning either data or failure based on API response.

// example

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
