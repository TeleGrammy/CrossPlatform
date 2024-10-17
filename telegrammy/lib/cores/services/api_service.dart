import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService({required this.dio});

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

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String idToken = googleAuth.idToken!;

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

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
