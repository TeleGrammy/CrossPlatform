// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:telegrammy/cores/services/api_service.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'sign_in_test.mocks.dart';

// Future<bool> _mockCanLaunchUrl(Uri url) async {
//   return true;
// }

// Future<bool> _mockLaunchUrl(Uri url) async {
//   return true;
// }

// // Generate Mocks
// @GenerateMocks([Dio, FlutterSecureStorage])
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized

//   late MockDio mockDio;
//   late MockFlutterSecureStorage mockSecureStorage;
//   late ApiService apiService;

//   setUp(() {
//     mockDio = MockDio();
//     mockSecureStorage = MockFlutterSecureStorage();
//     apiService = ApiService(dio: mockDio);
//   });

//   group('signInWithGoogle', () {
//     test('should launch Google sign-in URL successfully', () async {
//       // Arrange
//       const googleUrl = 'http://backtest.telegrammy.tech:8080/api/v1/auth/google';
//       final Uri url = Uri.parse(googleUrl);

//       // Mock `canLaunchUrl`
//       when(()=>canLaunchUrl(url)).thenAnswer((_) async => true);

//       // Mock `launchUrl`
//       when(launchUrl(url, mode: LaunchMode.externalApplication))
//           .thenAnswer((_) async => true);

//       // Act
//       final result = await apiService.signInWithGoogle();

//       // Assert
//       expect(result, Right(null));
//     });

//     test('should return an error if cannot launch Google URL', () async {
//       // Arrange
//       const googleUrl = 'http://backtest.telegrammy.tech:8080/api/v1/auth/google';
//       final Uri url = Uri.parse(googleUrl);

//       // Mock `canLaunchUrl` to return false
//       when(()=>canLaunchUrl(url)).thenAnswer((_) async => false);

//       // Act
//       final result = await apiService.signInWithGoogle();

//       // Assert
//       expect(result, Left('Could not launch $url'));
//     });
//   });

//   // group('signInWithGitHub', () {
//   //   test('should launch GitHub sign-in URL successfully', () async {
//   //     // Arrange
//   //     const gitHubUrl = 'http://backtest.telegrammy.tech:8080/api/v1/auth/github';
//   //     final Uri url = Uri.parse(gitHubUrl);

//   //     // Mock `canLaunchUrl`
//   //     when(canLaunchUrl(url)).thenAnswer((_) async => true);

//   //     // Mock `launchUrl`
//   //     when(launchUrl(url, mode: LaunchMode.externalApplication))
//   //         .thenAnswer((_) async => true);

//   //     // Act
//   //     final result = await apiService.signInWithGitHub();

//   //     // Assert
//   //     expect(result, Right(null));
//   //   });

//   //   test('should return an error if cannot launch GitHub URL', () async {
//   //     // Arrange
//   //     const gitHubUrl = 'http://backtest.telegrammy.tech:8080/api/v1/auth/github';
//   //     final Uri url = Uri.parse(gitHubUrl);

//   //     // Mock `canLaunchUrl` to return false
//   //     when(canLaunchUrl(url)).thenAnswer((_) async => false);

//   //     // Act
//   //     final result = await apiService.signInWithGitHub();

//   //     // Assert
//   //     expect(result, Left('Could not launch $url'));
//   //   });
//   // });

//   // group('login', () {
//   //   test('should successfully log in with valid credentials', () async {
//   //     // Arrange
//   //     const loginData = {
//   //       'email': 'test@example.com',
//   //       'password': 'password123'
//   //     };
//   //     final response = Response(
//   //       requestOptions: RequestOptions(path: 'http://10.0.2.2:8080/api/v1/auth/login'),
//   //       statusCode: 200,
//   //     );

//   //     when(mockDio.post(
//   //       'http://10.0.2.2:8080/api/v1/auth/login',
//   //       data: loginData,
//   //     )).thenAnswer((_) async => response);

//   //     // Act
//   //     final result = await apiService.login(loginData);

//   //     // Assert
//   //     expect(result, Right(null));
//   //   });

//   //   test('should return invalid email or password on 404 error', () async {
//   //     // Arrange
//   //     const loginData = {
//   //       'email': 'wrong@example.com',
//   //       'password': 'password123'
//   //     };

//   //     when(mockDio.post(
//   //       'http://10.0.2.2:8080/api/v1/auth/login',
//   //       data: loginData,
//   //     )).thenThrow(
//   //       DioException(
//   //         requestOptions: RequestOptions(path: 'http://10.0.2.2:8080/api/v1/auth/login'),
//   //         response: Response(
//   //           statusCode: 404,
//   //           requestOptions: RequestOptions(path: 'http://10.0.2.2:8080/api/v1/auth/login'),
//   //         ),
//   //       ),
//   //     );

//   //     // Act
//   //     final result = await apiService.login(loginData);

//   //     // Assert
//   //     expect(result, Left('Invalid email or password.'));
//   //   });

//   //   test('should return a general error on other exceptions', () async {
//   //     // Arrange
//   //     const loginData = {
//   //       'email': 'test@example.com',
//   //       'password': 'password123'
//   //     };

//   //     when(mockDio.post(
//   //       'http://10.0.2.2:8080/api/v1/auth/login',
//   //       data: loginData,
//   //     )).thenThrow(Exception());

//   //     // Act
//   //     final result = await apiService.login(loginData);

//   //     // Assert
//   //     expect(result, Left('Something went wrong.'));
//   //   });
//   // });
// }
