import 'package:chat_app/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

import 'firebase_options.dart';
import 'package:flutter/services.dart';

late Size media;
void main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Used to stop the rotation of app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Firebase Database initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
