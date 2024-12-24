import 'package:firebase_messaging/firebase_messaging.dart';

class HandleNotifications {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  
  Future<String?> getToken() async {
    try {
      // Request permission for notifications
      print('inside');
      NotificationSettings settings = await firebaseMessaging.requestPermission();

     

        // Get the token
        String? token = await firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token: $token');
          return token; // Return the token
        } else {
          print('FCM Token is null.');
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
