import 'dart:developer';

import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/main.dart';
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
    media = MediaQuery.of(context).size;
    return Scaffold(
      // App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(media.height * 70 / 926),
        child: AppBar(
          automaticallyImplyLeading: false,
          // App Text
          title: Text(
            "Welcome to We Chat",
            style: TextStyle(fontSize: media.height * 28 / 926),
          ),
        ),
      ),

      //  Body of Splash screen
      body: Stack(
        children: [
          // App Icon
          Positioned(
            top: media.height * 150 / 926,
            right: media.width * 89 / 428,
            left: media.width * 89 / 428,
            child: Image.asset(
              'assets/Image/icon.png',
              width: media.height * 250 / 926,
              height: media.height * 250 / 926,
            ),
          ),

          // Text
          Positioned(
              bottom: media.height * 150 / 926,
              left: media.width * 25 / 428,
              right: media.width * 25 / 428,
              child: Text(
                'MADE IN INDIA WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: media.height * 21 / 926,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              )),
        ],
      ),
    );
  }
}
