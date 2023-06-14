import 'dart:io';

import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_dialogbar.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _handlegoogleBtnClick() {
    // For showing progressbar indicator
    Dialogs.showProgressBar(context);

    // Signin with google
    _signInWithGoogle().then(
      (user) async {
        // Hide progressbar indicator
        Navigator.pop(context);
        // If return value is null
        if (user != null) {
          // We chack user exist
          if ((await APIs.userexist())) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            APIs.createUser().then(
              (value) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                )
              },
            );
          }
        }
      },
    );
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
      Dialogs.showSnackbar(context, 'Something went wrong (check Internet!)');
      return null;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //  Body of Login page
        body: Center(
          // For give background color to the screen
          child: SizedBox(
            height: media.height,
            width: media.width,            
            // Login page content
            child: Stack(
              children: [
                // Image of login page
                Image.asset('${app_strings.imagePath}login.jpg',height: media.height * 600/ 926,width: media.width,fit: BoxFit.fill),             

                // Container with text
                Positioned(
                  top: media.height* 500/926,
                  child: Container(
                    height: media.height* 400/926,
                    width: media.width,
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
                      child: Column(
                        children: [
                          SizedBox(height: media.height * 50 / 926,),
                          Text('Enjoy the new experience of Chatting with global friends',style: TextStyle(fontSize: media.height * 34 / 926,fontWeight: FontWeight.bold),),
                          SizedBox(height: media.height * 25 / 926,),
                          Text('Connect people arround the world for free',style: TextStyle(color: Colors.grey,fontSize: media.height * 20 / 926),)
                        ],
                      ),
                    ),
                  )
                ),

                // Get start button
                Positioned(
                  top:media.height * 750 / 926,
                  left: media.width * 40 / 428,
                  right: media.width * 40 / 428,
                  child: SizedBox(
                    height: media.height * 70 / 926,
                    width: media.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                        elevation: 10,
                        shadowColor: Colors.purple
                      ),
                      onPressed: (){_handlegoogleBtnClick();}, 
                      child: Text('Get Started',style: TextStyle(fontSize: media.height * 25 / 926,fontWeight: FontWeight.bold,letterSpacing: 1,color: Colors.black),)
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// For SHA1 Key
// keytool -list -v -keystore "C:\Users\Abhishek Raut\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android