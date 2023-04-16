// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handlegoogleBtnClick() {
    // For showing progressbar indicator
    Dialogs.showProgressBar(context);

    // Signin with google
    _signInWithGoogle().then((user) async {
      // Hide progressbar indicator
      Navigator.pop(context);
      // If return value is null
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        // We chack user exist
        if ((await APIs.userexist())) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          APIs.createUser().then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                )
              });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // For handle exception --> like internet problem
    try {
      // Check internet connection of device
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something went wrong (check Internet!)');
      return null;
    }
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

      //  Body of Login page
      body: Stack(
        children: [
          // App Icon
          AnimatedPositioned(
            top: media.height * 150 / 926,
            right: _isAnimate ? media.width * 50 / 428 : -media.width * 590 / 428,
            left: media.width * 50 / 428,
            duration: const Duration(seconds: 2),
            child: Image.asset(
              'assets/Image/icon.png',
              width: media.height * 250 / 926,
              height: media.height * 250 / 926,
            ),
          ),

          // Google SignIn button
          Positioned(
            bottom: media.height * 120 / 926,
            left: media.width * 25 / 428,
            width: media.width * 378 / 428,
            height: media.height * 60 / 926,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(208, 98, 202, 101),
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                _handlegoogleBtnClick();
              },
              icon: Image.asset(
                'assets/Image/google.png',
                height: media.height * 50 / 926,
              ),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: media.height * 22 / 926, color: Colors.black),
                  children: const [
                    TextSpan(text: 'Login with '),
                    TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// For SHA1 Key
// keytool -list -v -keystore "C:\Users\Abhishek Raut\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
