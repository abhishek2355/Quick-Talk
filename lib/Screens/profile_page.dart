import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_profile_page_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

import '../utils/helpers/app_ui_helpers/app_iconbutton.dart';

class Profile extends StatefulWidget {
  final UserChat user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();

  // For show Profile picture
  String? _pickedImage;

  @override
  Widget build(BuildContext context) {
    // MediaQuery veriable
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // App Bar
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(media.height * app_heights.height70),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 181, 227, 248),
            iconTheme: IconThemeData(color: Colors.black, size: media.height * 28 / 926),
            title: Text(
              app_strings.appName,
              style: TextStyle(fontSize: media.height * 28 / 926, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // floating Action Button for add new user
        floatingActionButton: SizedBox(
          height: media.height * 50 / 926,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.black38,
            onPressed: () async {
              // Show the progressbar
              Dialogs.showProgressBar(context);

              // Sign out from the app
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      // For hide the progressbar
                      Navigator.pop(context);

                      // For moving to the home screen
                      Navigator.pop(context);

                      // For move to the login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  );
                },
              );
            },

            // Icon fo floating action button
            icon: Icon(Icons.logout, size: media.height * 28 / 926),

            // Text of floating action button
            label: Text(
              'Logout',
              style: TextStyle(fontSize: media.height * 21 / 926),
            ),
          ),
        ),

        // Body of the project
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: media.height,
            width: media.width,

            // Background color
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 52, 174, 231),
                ],
              ),
            ),

            // Content of screen
            child: Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 16 / 428,
                ),
                child: Column(
                  children: [
                    // SizedBox with height 40
                    SizedBox(
                      height: media.height * 40 / 926,
                    ),

                    // Profile picture
                    SizedBox(
                      height: media.height * 180 / 926,
                      child: Stack(
                        children: [
                          (_pickedImage != null)
                              ? // User profile image
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(media.height * 90 / 926),
                                  child: Image.file(
                                    File(_pickedImage!),
                                    height: media.height * 180 / 926,
                                    width: media.height * 180 / 926,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              :
                              // User profile image
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(media.height * 90 / 926),
                                  child: CachedNetworkImage(
                                    height: media.height * 180 / 926,
                                    width: media.height * 180 / 926,
                                    fit: BoxFit.fill,
                                    imageUrl: widget.user.image,
                                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                  ),
                                ),

                          // Edit profile picture icon
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    50,
                                  ),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(2, 4),
                                    color: Colors.black.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(media.height * 1 / 926),
                                child: InkWell(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                    size: media.height * 28 / 926,
                                  ),
                                  onTap: () {
                                    _showBottomSheet();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox with height 30
                    SizedBox(
                      height: media.height * 30 / 926,
                    ),

                    // Name of the user
                    Text(
                      widget.user.name,
                      style: TextStyle(color: Colors.black87, fontSize: media.height * 28 / 926, fontWeight: FontWeight.bold),
                    ),

                    // Mail of user
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black87, fontSize: media.height * 22 / 926),
                    ),

                    // SizedBox with height 80
                    SizedBox(
                      height: media.height * 80 / 926,
                    ),

                    // Name TextFormField
                    SizedBox(
                      height: media.height * 70 / 926,
                      child: ProfileChangeTextField(
                          userprofileinfo: widget.user.name, hintText: 'Enter name', lableText: 'Name', onSaveInfo: (val) => APIs.me.name = val ?? ' '),
                    ),

                    // SizedBox with height 20
                    SizedBox(
                      height: media.height * 20 / 926,
                    ),

                    // About TextFormField
                    SizedBox(
                      height: media.height * 70 / 926,
                      child: ProfileChangeTextField(
                        userprofileinfo: widget.user.about,
                        hintText: 'Enter About',
                        lableText: 'About',
                        onSaveInfo: (val) => APIs.me.about = val ?? ' ',
                      ),
                    ),

                    // SizedBox with height 60
                    SizedBox(
                      height: media.height * 60 / 926,
                    ),

                    // Update Button
                    IconsWithButton(formkey: _formkey, buttonIcon: Icons.history, buttonText: 'Update')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Bottom Sheet Bar
  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 152, 218, 248),
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: media.height * 30 / 926, bottom: media.height * 30 / 926),
          shrinkWrap: true,
          children: [
            Text(
              'Pick profile Photo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: media.height * 30 / 926, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: media.height * 30 / 926,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _pickedImage = image.path;
                      });

                      // Call function for update the image in database
                      log('Image path : ${image.path}');

                      APIs.updateProfilePicture(File(_pickedImage!));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 196, 243),
                      fixedSize: Size(media.height * 100 / 926, media.height * 100 / 926),
                      shape: const CircleBorder()),
                  child: Image.asset(
                    'assets/Image/camera.png',
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(
                          () {
                            _pickedImage = image.path;
                          },
                        );

                        // Call function for update the image in database
                        log('Image path : ${image.path}');

                        APIs.updateProfilePicture(File(_pickedImage!));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 95, 196, 243),
                        fixedSize: Size(media.height * 100 / 926, media.height * 100 / 926),
                        shape: const CircleBorder()),
                    child: Image.asset('assets/Image/photo.png'))
              ],
            ),
          ],
        );
      },
    );
  }
}
