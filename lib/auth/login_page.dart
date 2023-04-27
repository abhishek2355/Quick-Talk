import 'dart:io';

import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_bottomiconbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

import '../utils/helpers/app_ui_helpers/app_textfields.dart';

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
          child: Container(
            height: media.height,
            width: media.width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0x00b6fcd5),
                  Colors.lightBlue,
                ],
              ),
            ),

            // Login page content
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16),
                child: Column(
                  children: [
                    // SizedBox with height 60
                    SizedBox(
                      height: media.height * app_heights.height60,
                    ),

                    // App Name
                    Text(
                      app_strings.appName,
                      style: TextStyle(fontSize: media.height * app_heights.height50, fontWeight: FontWeight.bold),
                    ),

                    // SizedBox with height 60
                    SizedBox(
                      height: media.height * app_heights.height60,
                    ),

                    // App Icon
                    Image.asset(
                      '${app_strings.imagePath}icon.png',
                      width: media.height * app_heights.height200,
                      height: media.height * app_heights.height200,
                    ),

                    // Sizedbox with height 60
                    SizedBox(
                      height: media.height * app_heights.height60,
                    ),

                    // ignore: prefer_const_constructors
                    TextFormFields(
                        hintText: app_strings.loginpageEmailHintText,
                        iconName: CupertinoIcons.mail,
                        isPasswordTextField: false,
                        labelText: app_strings.loginpageEmailLableText),

                    // Sizedbox with height 20
                    SizedBox(
                      height: media.height * app_heights.height20,
                    ),

                    // ignore: prefer_const_constructors
                    TextFormFields(
                        hintText: app_strings.loginpagePasswordHintText,
                        iconName: CupertinoIcons.lock_circle,
                        isPasswordTextField: true,
                        labelText: app_strings.loginpagePasswordLableText),

                    // SizedBox with height 40
                    SizedBox(
                      height: media.height * app_heights.height40,
                    ),

                    // SizedBox with height 50
                    SizedBox(
                      height: media.height * app_heights.height50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // <-- Radius
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          app_strings.loginButtonText,
                          style: TextStyle(fontSize: media.height * app_heights.height21, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // Sizedbox with height 60
                    SizedBox(
                      height: media.height * app_heights.height60,
                    ),

                    // Divider

                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          height: media.height * app_heights.height1,
                          thickness: 1,
                        )),
                        Text(
                          '  OR  ',
                          style: TextStyle(fontSize: media.height * app_heights.height18),
                        ),
                        Expanded(
                            child: Divider(
                          height: media.height * app_heights.height1,
                          thickness: 1,
                        ))
                      ],
                    ),

                    // SizedBox with height 40
                    SizedBox(
                      height: media.height * app_heights.height40,
                    ),

                    // Bottom iconbar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LoginIcons(
                          imageName: 'google.png',
                          onTap: () {
                            _handlegoogleBtnClick();
                          },
                        ),
                        LoginIcons(
                          imageName: 'facebook.png',
                          onTap: () {},
                        ),
                        LoginIcons(
                          imageName: 'twitter.png',
                          onTap: () {},
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// For SHA1 Key
// keytool -list -v -keystore "C:\Users\Abhishek Raut\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
