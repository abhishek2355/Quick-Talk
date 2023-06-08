
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

import '../utils/helpers/app_ui_helpers/app_textfields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
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
                      style: TextStyle(fontSize: media.height * app_heights.height40, fontWeight: FontWeight.bold),
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

                    // Name TextFormFields
                    const TextFormFields(
                      hintText: app_strings.profilePageNameHintText,
                      iconName: CupertinoIcons.profile_circled,
                      isPasswordTextField: false,
                      labelText: app_strings.profilePageNameLableText
                    ),

                    // Sizedbox with height 10
                    SizedBox(
                      height: media.height * app_heights.height10,
                    ),

                    // email TextFormFields 
                    const TextFormFields(
                      hintText: app_strings.loginpageEmailHintText,
                      iconName: CupertinoIcons.mail,
                      isPasswordTextField: false,
                      labelText: app_strings.loginpageEmailLableText
                    ),

                    // Sizedbox with height 10
                    SizedBox(
                      height: media.height * app_heights.height10,
                    ),

                    // Password TextFormFields
                    const TextFormFields(
                      hintText: app_strings.registerPageSetPasswordHinttext,
                      iconName: CupertinoIcons.lock_circle,
                      isPasswordTextField: true,
                      labelText: app_strings.registerPageSetPasswordLabletext
                    ),

                    // Sizedbox with height 10
                    SizedBox(
                      height: media.height * app_heights.height10,
                    ),

                    // Phone TextFormFields
                    const TextFormFields(
                      hintText: app_strings.mobileNumberHinttext,
                      iconName: CupertinoIcons.phone_circle,
                      isPasswordTextField: false,
                      labelText: app_strings.mobileNumberLabletext
                    ),

                    // SizedBox with height 40
                    SizedBox(
                      height: media.height * app_heights.height40,
                    ),

                    // Register Button
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
                          app_strings.registerButtonTextLable,
                          style: TextStyle(fontSize: media.height * app_heights.height21, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // Sizedbox with height 60
                    SizedBox(
                      height: media.height * app_heights.height60,
                    ),
                    
                    // Already having account                  
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an Account?', style: TextStyle(fontSize: media.height * 20 / 926,color: Colors.white70)),
                          Text(' Login' , style: TextStyle(fontSize: media.height * 20 / 926,color: Colors.black,fontWeight: FontWeight.bold))
                        ],
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),)),
                    ),
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