import 'package:chat_app/Screens/home_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Animation Variable
  bool _isAnimate = false;
  
  @override
  void initState() {
    super.initState();

    // For give an animation to the app icon
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAnimate = true;
      });
    });

    // For navigate from splash screen to the login screen or home screen
    Future.delayed(
      const Duration(seconds: 6),
      () {
        // If user already logged in
        if (APIs.auth.currentUser != null) {
          //navigate to home screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          //navigate to login screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Media Query veriable
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        // Background color
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

          // Splash screen content
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              curve: Curves.fastOutSlowIn,
              width: _isAnimate ? media.height * app_heights.height250 : media.height * app_heights.height150,
              height: _isAnimate ? media.height * app_heights.height250 : media.height * app_heights.height150,
              child: Image.asset(
                '${app_strings.imagePath}icon.png',
                width: media.height * app_heights.height250,
                height: media.height * app_heights.height250,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
