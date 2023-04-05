import 'dart:developer';

import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      // If user already logged in
      if (APIs.auth.currentUser != null) {
        log('/nUser : $APIs.auth.currentUser');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      // App Bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // App Text
        title: Text(
          "Welcome to We Chat",
          style: TextStyle(fontSize: media.height * 28 / 926),
        ),
      ),

      //  Body of Login page
      body: Stack(
        children: [
          // App Icon
          Positioned(
            top: media.height * 150 / 926,
            right: media.width * 80 / 428,
            width: media.width * 250 / 428,
            height: media.height * 250 / 926,
            child: Image.asset(
              'assets/Image/icon.png',
            ),
          ),

          // Google SignIn button
          Positioned(
              bottom: media.height * 120 / 926,
              left: media.width * 25 / 428,
              width: media.width * 378 / 428,
              height: media.height * 60 / 926,
              child: Text(
                'MADE IN INDIA WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: media.height * 21 / 926,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              )),
        ],
      ),
    );
  }
}
