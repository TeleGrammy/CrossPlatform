// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCpcsNX8qfx2PF6Nhhln3_fi3Pa_jy30HQ',
    appId: '1:4445093650:web:17a8a4b7cae75b28da3dcb',
    messagingSenderId: '4445093650',
    projectId: 'telegrammy-d0854',
    authDomain: 'telegrammy-d0854.firebaseapp.com',
    storageBucket: 'telegrammy-d0854.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAI3_MGUOjVxSXQVRnjCPeQhRJJ5QIUbvk',
    appId: '1:4445093650:android:eb11f97ff0392949da3dcb',
    messagingSenderId: '4445093650',
    projectId: 'telegrammy-d0854',
    storageBucket: 'telegrammy-d0854.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg7Rx-x-2NkOe2He3TXKRsX52eIIZx39U',
    appId: '1:4445093650:ios:81037b4f7637e472da3dcb',
    messagingSenderId: '4445093650',
    projectId: 'telegrammy-d0854',
    storageBucket: 'telegrammy-d0854.appspot.com',
    iosBundleId: 'com.example.telegrammy',
  );
}
