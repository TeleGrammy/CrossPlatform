import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github/github.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
// import 'package:flutter_web_auth_plus/flutter_web_auth_plus.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

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

  // Future<void> signInWithGoogle() async {
  //   final url = "http://192.168.0.102:8080/api/v1/auth/google";

  //   try {
  //     // Launch the URL and listen for the callback URL
  //     final result = await FlutterWebAuth.authenticate(
  //         url: url,
  //         callbackUrlScheme:
  //             "myapp" // match the scheme in the URL returned by backend
  //         );

  //     // Extract the token from the result
  //     final token = Uri.parse(result).queryParameters['token'];

  //     if (token != null) {
  //       // Store the token and navigate in the app as needed
  //       print(token);
  //       // await saveToken(token);
  //       // navigateToHomeScreen();
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // Future<void> signInWithGoogle() async {
  //   final url = "http://backtest.telegrammy.tech:8080/api/v1/auth/google";

  //   try {
  //     // Launch the URL and listen for the callback URL
  //     final result = await FlutterWebAuth.authenticate(
  //         url: url,
  //         callbackUrlScheme:
  //             "myapp" // match the scheme in the URL returned by backend
  //         );

  //     // Extract the token from the result
  //     final token = Uri.parse(result).queryParameters['token'];
  //     print(token);
  //     if (token != null) {
  //       // Store the token and navigate in the app as needed
  //       // await saveToken(token);
  //       // navigateToHomeScreen();
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // Future<void> signInWithGoogle() async {
  //   // initUniLinks();
  //   const url = 'http://192.168.0.102:8080/api/v1/auth/google';

  //   try {
  //     final Uri uri = Uri.parse(url); // Create a Uri object from the string
  //     await launchUrl(uri,
  //         mode: LaunchMode
  //             .externalApplication); // Use launchUrl with the Uri object
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Future<void> signInWithGoogle() async {
    try {
      final Uri url =
          Uri.parse('http://backtest.telegrammy.tech:8080/api/v1/auth/google');
      // if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Open in external browser
      );
      // } else {
      //   throw 'Could not launch $url';
      // }

      print('success');
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) {
      //   throw Exception('Sign-in aborted by user'); // User canceled the sign-in
      // }
      // print(googleUser);
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser.authentication;
      // print(googleAuth?.idToken);
      // final String idToken = googleAuth!.idToken!;
      // print(idToken);
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
    final Uri url =
        Uri.parse('http://backtest.telegrammy.tech:8080/api/v1/auth/github');
    // if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Open in external browser
    );
    // } else {
    //   throw 'Could not launch $url';
    // }

    print('success');
    // final clientId = 'Ov23lickxMhmwQkCMM4W';
    // final clientSecret = 'c2316813977f0abdbb00650f299a3925ced6272b';
    //    const String url = "https://github.com/login/oauth/authorize" +
    //       "?client_id=" + 'Ov23lickxMhmwQkCMM4W' +
    //       "&scope=public_repo%20read:user%20user:email";
    // if (await canLaunch(url)) {
    //     await launch(
    //       url,
    //       forceSafariVC: false,
    //       forceWebView: false,
    //     );
    //   } else {
    //     print("CANNOT LAUNCH THIS URL!");
    //   }

    // GithubAuthProvider githubAuthProvider = GithubAuthProvider();
    // UserCredential userCredential =
    //     await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
    // print(userCredential);
    // return userCredential;
    // final firebaseAuth = FirebaseAuth.instance;
    // final dio = Dio();

    // // GitHub OAuth URL
    // final clientId = 'Ov23lickxMhmwQkCMM4W';
    // final clientSecret = 'c2316813977f0abdbb00650f299a3925ced6272b';
    // final redirectUrl =
    //     'https://telegrammy-d0854.firebaseapp.com/__/auth/handler';

    // // Step 1: Trigger the GitHub authentication process
    // final result = await FlutterWebAuth.authenticate(
    //   url:
    //       'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl',
    //   callbackUrlScheme: 'https',
    // );

    // // Step 2: Extract the code from the callback URL
    // final code = Uri.parse(result).queryParameters['code'];

    // // Step 3: Exchange the code for an access token using Dio
    // try {
    //   final response = await dio.post(
    //     'https://github.com/login/oauth/access_token',
    //     data: {
    //       'client_id': clientId,
    //       'client_secret': clientSecret,
    //       'code': code,
    //     },
    //     options: Options(
    //       headers: {
    //         'Accept': 'application/json',
    //       },
    //     ),
    //   );

    //   final accessToken = response.data['access_token'];

    //   // Step 4: Use the GitHub access token to sign in with Firebase
    //   final githubAuthCredential = GithubAuthProvider.credential(accessToken);

    //   return await firebaseAuth.signInWithCredential(githubAuthCredential);
    // } on DioException catch (e) {
    //   print("Error during GitHub sign-in: ${e.response?.data}");
    //   throw e;
    // }

//  final github = GitHub(
//     clientId: 'YOUR_CLIENT_ID',
//     clientSecret: 'YOUR_CLIENT_SECRET',
//     redirectUrl: 'yourapp://auth',
//   );

//   try {
//     final authUrl = github.getAuthorizationUrl();
//     // Use a webview or browser to navigate to authUrl.
//     // After user authenticates, GitHub will redirect to the callback with a code.

//     // Retrieve the code from the redirect and exchange it for an access token.
//     final token = await github.exchangeOAuthCodeForToken(code);
//     // Use the token to make authenticated requests.
//   } catch (error) {
//     print('GitHub sign-in failed: $error');
//   }

    // final clientId = 'Ov23lickxMhmwQkCMM4W';
    // // final redirectUri =
    // //     'http://localhost:8000/auth/callback'; // Same as in GitHub settings
    // final redirectUri = 'telegrammy://auth';

    // final url = Uri.https('github.com', '/login/oauth/authorize', {
    //   'client_id': clientId,
    //   'redirect_uri': redirectUri,
    //   'scope': 'read:user user:email',
    // });
    // print(url.toString());
    // // Open the GitHub login page
    // final result = await FlutterWebAuth.authenticate(
    //     url: url.toString(), callbackUrlScheme: "telegrammy");

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
  }

  Future<Either<String, void>> login(userLoginData) async {
    try {
      final response = await getit
          .get<Dio>()
          .post('http://10.0.2.2:8080/api/v1/auth/login', data: userLoginData);

      setTokenInLocalStorage(response);

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
        'http://10.0.2.2:8080/api/v1/auth/forget-password', // Use 10.0.2.2 for emulator
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
}
