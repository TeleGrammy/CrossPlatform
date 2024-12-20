import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dio/dio.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/notifications/data/handle_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
// import 'package:flutter_web_auth_plus/flutter_web_auth_plus.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ApiService {
  ApiService({required this.dio});
  final Dio dio;

  Future<Either<String, void>> signInWithGoogle() async {
    try {
      final Uri url = Uri.parse('http://telegrammy.tech/api/v1/auth/google');

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Open in external browser
      );

      return Right(null);
      // If successful, do nothing and return void
    } catch (error) {
      return left('Sign-in error: $error');
    }
  }

  Future<Either<String, void>> signInWithGitHub() async {
    try {
      final Uri url = Uri.parse('http://telegrammy.tech/api/v1/auth/github');
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Open in external browser
      );
      return Right(null);
    } catch (error) {
      return left('Sign-in error: $error');
    }
  }

// Function to exchange the authorization code for an access token using Dio
  Future<String?> getAccessToken(String code) async {
    final clientId = 'Ov23lickxMhmwQkCMM4W';
    final clientSecret = 'c2316813977f0abdbb00650f299a3925ced6272b';

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://github.com/login/oauth/access_token',
        options: Options(headers: {
          'Accept': 'application/json',
        }),
        data: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      }
    } catch (e) {
      print("Error getting access token: $e");
    }

    return null;
  }

  Future<void> signUpUser(Map<String, dynamic> userData) async {
    try {
      print(userData);
      final signUpResponse = await dio.post(
        '$baseUrl$registerPath',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "email": userData['email'],
          "username": userData['username'],
          "password": userData['password'],
          "passwordConfirm": userData['passwordConfirm'],
          "phone": userData['phone'],
          "token": userData['captcha']
        },
      );

      print('signUpResponse.statusCode ${signUpResponse.statusCode}');

      if (signUpResponse.statusCode == 201) {
        print('User signed up successfully');
        await getit.get<TokenStorageService>().saveEmail(userData['email']);
      } else {
        throw Exception('error occured while signing you up');
      }
    } on DioException catch (dioError) {
      print('Dio error occurred: ${dioError.message}'); // Log the error message
      print(
          'Response: ${dioError.response?.data}'); // Log the response data if available
      throw Exception(
          'Error: ${dioError.response?.data['error'] ?? 'An error occurred'}');
    }
  }

  Future<void> emailVerification(String email, String verificationCode) async {
    try {
      final response = await dio.post(
        '$baseUrl$verificationPath',
        data: {
          "email": email,
          "verificationCode": verificationCode,
        },
      );

      if (response.statusCode == 200) {
        dynamic token = response.data['data']['accessToken'];
        print('Account verified successfully:${response.data}');
        await getit.get<TokenStorageService>().deleteEmail();
        await getit.get<TokenStorageService>().saveToken(token);
      } else {
        throw Exception('Failed to verify Account');
      }
    } on DioException catch (dioError) {
      throw Exception(
          'Error: ${dioError.response?.data['error'] ?? 'An error occurred'}');
    }
  }

  Future<void> resendEmailVerification(String email) async {
    try {
      final response = await dio.post(
        '$baseUrl$resendVerificationPath',
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        print('verivication code sent successfully $response');
      } else {
        throw Exception('Failed to resend verification code');
      }
    } on DioException catch (dioError) {
      throw Exception(
          'Error: ${dioError.response?.data['message'] ?? 'An error occurred'}');
    }
  }

  void setTokenInLocalStorage(response) async {
    await getit
        .get<FlutterSecureStorage>()
        .write(key: 'accessToken', value: response.data['data']['accessToken']);
    print(response.data['data']['accessToken']);
  }

  Future<Either<String, void>> login(userLoginData) async {
    try {
      print(userLoginData);
      // final tokenn=await HandleNotifications().getToken();
      // print(tokenn);
      print('$baseUrl/auth/login');
      final response = await getit
          .get<Dio>()
          .post('$baseUrl2/auth/login', data: userLoginData);
      print(response);
      setTokenInLocalStorage(response);
      print(response);
      // print(userLoginData);

      return const Right(null);
    } on DioException catch (DioException) {
      print(DioException);
      if (DioException.response != null) {
        if (DioException.response?.statusCode == 404) {
          return const Left<String, void>('Invalid email or password.');
        }
      }
      return const Left<String, void>('Something went wrong.');
    } catch (e) {
      return const Left<String, void>('Something went wrong.');
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      final response = await dio.post(
        'http://telegrammy.tech/api/v1/auth/forget-password', // Use 10.0.2.2 for emulator
        data: {
          'email': email,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Verification code sent successfully: ${response.data}');
      } else {
        throw Exception('Failed to resend verification code');
      }
    } on DioException catch (dioError) {
      String errorMessage =
          dioError.response?.data['message'] ?? 'An error occurred';
      print('Dio error: $errorMessage'); // Log the error message
      throw Exception('Error: $errorMessage'); // Re-throw the exception
    } catch (e) {
      print('General error: $e'); // Log the general error
      throw Exception(
          'An unexpected error occurred'); // Provide a general error message
    }
  }

  // Future<void> forgetPassword(email) async {
  //   try {
  //     final response = await getit.get<Dio>().post(
  //         'http://10.0.2.2:8080/api/v1/forget-password',
  //         data: {'email': email});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> resetPassword(password, newPassword) async {
  //   try {
  //     // final userLoginData = {'UUID': email, 'password': password};
  //     final response = await getit
  //         .get<Dio>()
  //         .post('http://10.0.2.2:8080/api/v1/auth/login', data: userLoginData);

  //     await getit.get<FlutterSecureStorage>().write(
  //         key: 'accessToken', value: response.data['data']['accessToken']);

  //     // context.goNamed(RouteNames.home);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List<Chat>> fetchChats() async {
    try {
      //const String token =
      //    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjEyOWFlN2ZmMjZlOGZjNzk5MGQ1ZSIsIm5hbWUiOiJtb2hhbWVkMjIiLCJlbWFpbCI6Im1rMDAxNTI2NEBnbWFpbC5jb20iLCJwaG9uZSI6IjAxMDEwMTAxMDExMSIsImxvZ2dlZE91dEZyb21BbGxEZXZpY2VzQXQiOm51bGwsImlhdCI6MTczMjkwMzMyNiwiZXhwIjoxNzMyOTA2OTI2LCJhdWQiOiJteWFwcC11c2VycyIsImlzcyI6Im15YXBwIn0.5VPSWqkgIdW6KVRBPQP0yaUTezIm1yeXxz6NUooSvC0';
      String? token = await getit.get<TokenStorageService>().getToken();
      // print(token);
      // final response = await getit.get<Dio>().get(
      //       'http://10.0.2.2:8080/api/v1/chats/all-chats?page=1&limit=50',
      //       options: Options(
      //         headers: {
      //           'Authorization': 'Bearer $token',
      //         },
      //       ),
      //     );
      final response = await getit.get<Dio>().get(
            '$baseUrl/chats/all-chats?page=1&limit=50',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );
      // print(response);
      if (response.statusCode == 200) {
        final List<dynamic> chats = response.data['chats'];
        // final String userId = response.data['userId'];
        return chats.map((chat) => Chat.fromJson(chat)).toList();
      } else {
        throw Exception('Failed to fetch contacts');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}
