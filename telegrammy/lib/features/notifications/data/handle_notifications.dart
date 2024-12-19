import 'package:firebase_messaging/firebase_messaging.dart';

class HandleNotifications {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  
  Future<String?> getToken() async {
    try {
      // Request permission for notifications
      NotificationSettings settings = await firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permission granted.');

        // Get the token
        String? token = await firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token: $token');
          return token; // Return the token
        } else {
          print('FCM Token is null.');
          return null;
        }
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('Notification permission denied.');
        return null;
      } else {
        print('Notification permission status: ${settings.authorizationStatus}');
        return null;
      }
    } catch (e) {
      print('Error retrieving token: $e');
      return null; // Return null in case of an error
    }
  }

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title} - ${message.notification?.body}');
}


}
