import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ApiService {
  ApiService({required this.dio});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile', // Access basic profile info
    ],
  );
  final Dio dio;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign-in aborted by user'); // User canceled the sign-in
      }
      print(googleUser);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // final String idToken = googleAuth.idToken!;

      // Send the ID token to the backend using Dio or another HTTP client.
      // Example:
      // final response = await dio.post(...);
      // if (response.statusCode != 200) {
      //   throw Exception('Sign-in failed: ${response.data['error']}');
      // }

      // If successful, do nothing and return void
    } catch (error) {
      throw Exception('Sign-in error: $error'); // Propagate error
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signInWithGitHub() async {
    final clientId = 'Ov23lickxMhmwQkCMM4W';
    final redirectUri =
        'http://localhost:8000/auth/callback'; // Same as in GitHub settings

    final url = Uri.https('github.com', '/login/oauth/authorize', {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': 'read:user user:email',
    });

    // Open the GitHub login page
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "yourapp");

    // Extract the code from the result
    final code = Uri.parse(result).queryParameters['code'];
    if (code != null) {
      // Exchange code for an access token
      final accessToken = await getAccessToken(code);
      if (accessToken != null) {
        // Use accessToken to fetch user details
        final userData = await getGitHubUser(accessToken);
        print("User Info: $userData");
      }
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

// Function to fetch user information from GitHub using Dio
  Future<Map<String, dynamic>?> getGitHubUser(String accessToken) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.github.com/user',
        options: Options(headers: {
          'Authorization': 'token $accessToken',
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
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
}
