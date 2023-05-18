import 'dart:developer';

import 'package:chat_app/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'firebase_options.dart';
import 'package:flutter/services.dart';

late Size media;
void main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'quick_talk',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Quick Talk',
  );
  log('\nNotification Channel result: $result');

  // Run the main application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // For remove debug banner from we chat application
      debugShowCheckedModeBanner: false,

      // Title for the application
      title: app_strings.appName,

      // Splashscreen call
      home: SplashScreen(),
    );
  }
}
