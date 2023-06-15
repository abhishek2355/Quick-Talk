import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_profile_page_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

import '../utils/helpers/app_ui_helpers/app_dialogbar.dart';
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
      child: Container(
        color: const Color.fromARGB(255, 181, 227, 248),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // App Bar
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(media.height * app_heights.height70),
              child: AppBar(
                backgroundColor:  Colors.white,
                iconTheme: IconThemeData(color: Colors.black, size: media.height * app_heights.height28),
                title: Text(
                  app_strings.appName,
                  style: TextStyle(fontSize: media.height * app_heights.height28, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // floating Action Button for add new user
            floatingActionButton: SizedBox(
              height: media.height * app_heights.height50,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.black38,
                onPressed: () async {
                  // Show the progressbar
                  Dialogs.showProgressBar(context);

                  await APIs.updateActiveStatus(false);

                  // Sign out from the app
                  await APIs.auth.signOut().then(
                    (value) async {
                      await GoogleSignIn().signOut().then(
                        (value) {
                          // For hide the progressbar
                          Navigator.pop(context);

                          // For moving to the home screen
                          Navigator.pop(context);

                          APIs.auth = FirebaseAuth.instance;

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

                // Icon for floating action button
                icon: Icon(Icons.logout, size: media.height * app_heights.height28),

                // Text of floating action button
                label: Text(
                  app_strings.profilePageLogoutText,
                  style: TextStyle(fontSize: media.height * app_heights.height21),
                ),
              ),
            ),

            // Body of the project
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: media.height,
                width: media.width,

                // Content of screen
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: media.width * app_widths.width16,
                    ),
                    child: Column(
                      children: [
                        // SizedBox with height 40
                        SizedBox(
                          height: media.height * app_heights.height40,
                        ),

                        // Profile picture
                        SizedBox(
                          height: media.height * app_heights.height180,
                          child: Stack(
                            children: [
                              (_pickedImage != null)
                                  ? // User profile image
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(media.height * app_heights.height90),
                                      child: Image.file(
                                        File(_pickedImage!),
                                        height: media.height * app_heights.height180,
                                        width: media.height * app_heights.height180,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  :
                                  // User profile image
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(media.height * app_heights.height90),
                                      child: CachedNetworkImage(
                                        height: media.height * app_heights.height180,
                                        width: media.height * app_heights.height180,
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
                                    padding: EdgeInsets.all(media.height * app_heights.height1),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.black,
                                        size: media.height * app_heights.height28,
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
                          height: media.height * app_heights.height30,
                        ),

                        // Name of the user
                        Text(
                          widget.user.name,
                          style: TextStyle(color: Colors.black87, fontSize: media.height * app_heights.height28, fontWeight: FontWeight.bold),
                        ),

                        // Mail of user
                        Text(
                          widget.user.email,
                          style: TextStyle(color: Colors.black87, fontSize: media.height * app_heights.height22),
                        ),

                        // SizedBox with height 80
                        SizedBox(
                          height: media.height * app_heights.height80,
                        ),

                        // Name TextFormField
                        SizedBox(
                          height: media.height * app_heights.height70,
                          child: ProfileChangeTextField(
                              userprofileinfo: widget.user.name,
                              hintText: app_strings.profilePageNameHintText,
                              lableText: app_strings.profilePageNameLableText,
                              onSaveInfo: (val) => APIs.me.name = val ?? ' '),
                        ),

                        // SizedBox with height 20
                        SizedBox(
                          height: media.height * app_heights.height20,
                        ),

                        // About TextFormField
                        SizedBox(
                          height: media.height * app_heights.height70,
                          child: ProfileChangeTextField(
                            userprofileinfo: widget.user.about,
                            hintText: app_strings.profilePageAboutHintText,
                            lableText: app_strings.profilePageAboutLableText,
                            onSaveInfo: (val) => APIs.me.about = val ?? ' ',
                          ),
                        ),

                        // SizedBox with height 60
                        SizedBox(
                          height: media.height * app_heights.height60,
                        ),

                        // Update Button
                        IconsWithButton(formkey: _formkey, buttonIcon: Icons.history, buttonText: app_strings.profileUpdateButtonText)
                      ],
                    ),
                  ),
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
          padding: EdgeInsets.only(top: media.height * app_heights.height30, bottom: media.height * app_heights.height30),
          shrinkWrap: true,
          children: [
            Text(
              app_strings.profilebottomSheetText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: media.height * app_heights.height30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: media.height * app_heights.height30,
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

                      APIs.updateProfilePicture(File(_pickedImage!));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 196, 243),
                      fixedSize: Size(media.height * app_heights.height100, media.height * app_heights.height100),
                      shape: const CircleBorder()),
                  child: Image.asset(
                    '${app_strings.imagePath}camera.png',
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

                        APIs.updateProfilePicture(File(_pickedImage!));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 95, 196, 243),
                        fixedSize: Size(media.height * app_heights.height100, media.height * app_heights.height100),
                        shape: const CircleBorder()),
                    child: Image.asset('${app_strings.imagePath}photo.png'))
              ],
            ),
          ],
        );
      },
    );
  }
}
