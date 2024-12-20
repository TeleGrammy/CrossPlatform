import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/notifications/data/handle_notifications.dart';
import 'package:telegrammy/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    setupServiceLocator();
    //  final tokenn=await HandleNotifications().getToken();
    //   print('tokenmmmmmmm$tokenn');
        //  FirebaseMessaging.onBackgroundMessage(HandleNotifications().firebaseMessagingBackgroundHandler);
    runApp(const MyApp());
  } catch (e, stack) {
    print('Error during initialization: $e\n$stack');
  }
}
  



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.goRouter,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(255, 15, 118, 146)),
    );
  }
}
