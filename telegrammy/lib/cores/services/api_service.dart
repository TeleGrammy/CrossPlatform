import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
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

  // Future<void> initUniLinks() async {
  //   StreamSubscription sub = uriLinkStream.listen((Uri? uri) {
  //     if (uri != null && uri.scheme == 'http://192.168.0.102:5173') {
  //     }
  //   });
  // }

// Function to launch Google Sign-In
  Future<void> signInWithGoogle() async {
    // initUniLinks();
    const url = 'http://192.168.0.102:8080/api/v1/auth/google';

    try {
      final Uri uri = Uri.parse(url); // Create a Uri object from the string
      await launchUrl(uri,
          mode: LaunchMode
              .externalApplication); // Use launchUrl with the Uri object
    } catch (e) {
      print(e);
    }
  }

  // Future<void> signInWithGoogle() async {
  //   final response = await dio.get('http://10.0.2.2:8080/api/v1/auth/google');
  //   print(response);
  //   // try {
  //   //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   //   if (googleUser == null) {
  //   //     throw Exception('Sign-in aborted by user'); // User canceled the sign-in
  //   //   }
  //   //   print(googleUser);
  //   //   final GoogleSignInAuthentication googleAuth =
  //   //       await googleUser.authentication;
  //   //   // final String idToken = googleAuth.idToken!;

  //   //   // Send the ID token to the backend using Dio or another HTTP client.
  //   //   // Example:
  //   //   // final response = await dio.post(...);
  //   //   // if (response.statusCode != 200) {
  //   //   //   throw Exception('Sign-in failed: ${response.data['error']}');
  //   //   // }

  //   //   // If successful, do nothing and return void
  //   // } catch (error) {
  //   //   throw Exception('Sign-in error: $error'); // Propagate error
  //   // }
  // }

  Future<void> signInWithFacebook() async {
    const url = 'http://10.0.2.2:8080/api/v1/auth/github';

    // const url = 'http://192.168.0.102:8080/api/v1/auth/github';

    try {
      final Uri uri = Uri.parse(url); // Create a Uri object from the string
      print(uri);
      await launchUrl(uri,
          mode: LaunchMode
              .externalApplication); // Use launchUrl with the Uri object
    } catch (e) {
      print(e);
    }
    // // Trigger the sign-in flow
    // final LoginResult loginResult = await FacebookAuth.instance.login();

    // // Create a credential from the access token
    // final OAuthCredential facebookAuthCredential =
    //     FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // // Once signed in, return the UserCredential
    // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signInWithGitHub() async {
    const url = 'http://192.168.0.102:8080/api/v1/auth/github';

    try {
      final Uri uri = Uri.parse(url); // Create a Uri object from the string
      print(uri);
      await launchUrl(uri,
          mode: LaunchMode
              .externalApplication); // Use launchUrl with the Uri object
    } catch (e) {
      print(e);
    }
    // final clientId = 'Ov23lickxMhmwQkCMM4W';
    // final redirectUri =
    //     'http://localhost:8000/auth/callback'; // Same as in GitHub settings

    // final url = Uri.https('github.com', '/login/oauth/authorize', {
    //   'client_id': clientId,
    //   'redirect_uri': redirectUri,
    //   'scope': 'read:user user:email',
    // });

    // // Open the GitHub login page
    // final result = await FlutterWebAuth.authenticate(
    //     url: url.toString(), callbackUrlScheme: "yourapp");

    // // Extract the code from the result
    // final code = Uri.parse(result).queryParameters['code'];
    // if (code != null) {
    //   // Exchange code for an access token
    //   final accessToken = await getAccessToken(code);
    //   if (accessToken != null) {
    //     // Use accessToken to fetch user details
    //     final userData = await getGitHubUser(accessToken);
    //     print("User Info: $userData");
    //   }
    // }
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

  Future<void> login(userLoginData) async {
    try {
      // final userLoginData = {'UUID': email, 'password': password};
      final response = await getit
          .get<Dio>()
          .post('http://10.0.2.2:8080/api/v1/auth/login', data: userLoginData);

      await getit.get<FlutterSecureStorage>().write(
          key: 'accessToken', value: response.data['data']['accessToken']);

      // context.goNamed(RouteNames.home);
    } catch (e) {
      print(e);
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
}
