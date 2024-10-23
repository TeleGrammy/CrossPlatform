// This file handles all authentication-related tasks.
//
// Functions:
// - registerWithEmail(String email, String password): Registers a new user using email and password.
// - loginWithEmail(String email, String password): Logs a user in using email and password.
// - logout(): Logs the user out of the app.
// - socialLogin(String provider): Logs the user in using a social account (e.g., Google, Facebook, GitHub).
// - resendVerificationCode(): Resends the verification code to the user's email.
// - resetPassword(String email): Sends a password reset link to the provided email.
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ApiService {
  final Dio dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ApiService({required this.dio});

  Future<void> signUpUser(Map<String, dynamic> userData) async {
    try {
      // Register user with email and password using Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );

      await userCredential.user?.sendEmailVerification();

      String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        await getit.get<TokenStorageService>().saveToken(token);
        await getit
            .get<TokenStorageService>()
            .saveCaptchaToken(userData['captcha']);
      }
      //API approach
      // final response = await dio.post(
      //   '/register',
      //   data: userData,
      // );

      // if (response.statusCode == 200) {
      //   print('user signed up successfully');
      //   // Handle token saving
      //   final token =
      //       response.data['token']; // Assuming the token is in the response
      //   await getit.get<TokenStorageService>().saveToken(token);
      // } else {
      //   throw Exception('Failed to register user');
      // }  } on DioException catch (dioError) {
      //   throw Exception(
      //       'Error: ${dioError.response?.data['message'] ?? 'An error occurred'}');
      // }
      print('User signed up successfully and data stored in Firestore');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception('Failed to sign up user: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error occurred during sign-up: ${e.toString()}');
    }
  }

  Future<void> emailVerification(String email, String verificationCode) async {
    try {
      final response = await dio.post(
        '/verify',
        data: {
          'email': email,
          'verificationCode': verificationCode,
        },
      );

      if (response.statusCode == 200) {
        print('Account verified successfully');
      } else {
        throw Exception('Failed to verify Account');
      }
    } on DioException catch (dioError) {
      throw Exception(
          'Error: ${dioError.response?.data['message'] ?? 'An error occurred'}');
    }
  }

  Future<void> resendEmailVerification(String email) async {
    try {
      final response = await dio.post(
        '/resend-verification',
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        print('verivication code sent successfully');
      } else {
        throw Exception('Failed to resend verification code');
      }
    } on DioException catch (dioError) {
      throw Exception(
          'Error: ${dioError.response?.data['message'] ?? 'An error occurred'}');
    }
  }
}
