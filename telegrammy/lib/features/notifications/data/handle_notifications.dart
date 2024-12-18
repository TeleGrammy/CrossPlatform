import 'package:firebase_messaging/firebase_messaging.dart';

class HandleNotifications {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> getToken() async {
    try {
      // Request permission for notifications (optional for iOS)
      NotificationSettings settings = await firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permission granted.');

        // Get the token
        String? token = await firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token: $token');
          // Save or send the token to your server here
        } else {
          print('FCM Token is null.');
        }
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('Notification permission denied.');
      } else {
        print('Notification permission status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      print('Error retrieving token: $e');
    }
  }
}
