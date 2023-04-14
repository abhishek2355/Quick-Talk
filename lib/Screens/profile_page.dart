import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
          // App Bar
          appBar: AppBar(
            // App Text
            title: Text(
              "We Chat",
              style: TextStyle(fontSize: media.height * 28 / 926),
            ),
          ),

          // floating Action Button for add new user
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              // Show the progressbar
              Dialogs.showProgressBar(context);

              // Sign out from the app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
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
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),

          // Body of the project
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * .05,
                ),
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(
                      width: media.width,
                      height: media.height * .03,
                    ),

                    Stack(
                      children: [
                        (_pickedImage != null)
                            ? // User profile image
                            ClipRRect(
                                borderRadius: BorderRadius.circular(media.height * 90 / 926),
                                child: Image.file(
                                  File(_pickedImage!),
                                  height: media.height * 180 / 926,
                                  width: media.height * 180 / 926,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :
                            // User profile image
                            ClipRRect(
                                borderRadius: BorderRadius.circular(media.height * 90 / 926),
                                child: CachedNetworkImage(
                                  height: media.height * 180 / 926,
                                  width: media.height * 180 / 926,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: media.width * 180 / 926,
                          child: MaterialButton(
                            height: media.height * 50 / 926,
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: media.height * 25 / 926,
                            ),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(
                      height: media.height * .03,
                    ),

                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: media.height * 25 / 926),
                    ),

                    // for adding some space
                    SizedBox(
                      height: media.height * .05,
                    ),

                    SizedBox(
                      height: media.height * 70 / 926,

                      // Textformfield of name
                      child: TextFormField(
                        // Initial value
                        initialValue: widget.user.name,
                        // What to save
                        onSaved: (val) => APIs.me.name = val ?? ' ',
                        // Validate the entered value
                        validator: (val) => (val != null && val.isNotEmpty) ? null : 'Enter Something',

                        style: TextStyle(fontSize: media.height * 25 / 926),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            contentPadding: EdgeInsets.symmetric(horizontal: media.height * 10 / 926),
                            prefixIcon: Icon(
                              Icons.person,
                              size: media.height * 25 / 926,
                              color: Colors.blue,
                            ),
                            hintText: "Enter Name",
                            label: const Text('Name')),
                      ),
                    ),

                    SizedBox(
                      height: media.height * .02,
                    ),

                    SizedBox(
                      height: media.height * 70 / 926,
                      child: TextFormField(
                        initialValue: widget.user.about,
                        onSaved: (val) => APIs.me.about = val ?? ' ',
                        validator: (val) => (val != null && val.isNotEmpty) ? null : 'Enter Something',
                        style: TextStyle(fontSize: media.height * 25 / 926),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            contentPadding: EdgeInsets.symmetric(horizontal: media.height * 10 / 926),
                            prefixIcon: Icon(
                              Icons.info_outline,
                              size: media.height * 25 / 926,
                              color: Colors.blue,
                            ),
                            hintText: "Enter something",
                            label: const Text('About')),
                      ),
                    ),
                    SizedBox(
                      height: media.height * .05,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          // For save the new information
                          _formkey.currentState!.save();

                          // update the informatio on firebase
                          APIs.updatedUserInformation();

                          // Show the Snackbar of updated profile
                          Dialogs.showSnackbar(context, 'Profile Successfully Updated');

                          print('Okk');
                        }
                      },
                      icon: Icon(
                        Icons.update,
                        size: media.height * 25 / 926,
                      ),
                      label: Text(
                        'Update',
                        style: TextStyle(fontSize: media.height * 25 / 926),
                      ),
                      style: ElevatedButton.styleFrom(shape: const StadiumBorder(), minimumSize: Size(media.width * .5, media.height * 0.06)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
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
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, fixedSize: Size(media.height * 100 / 926, media.height * 100 / 926), shape: const CircleBorder()),
                  child: Image.asset('assets/Image/camera.png'),
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
                        backgroundColor: Colors.white, fixedSize: Size(media.height * 100 / 926, media.height * 100 / 926), shape: const CircleBorder()),
                    child: Image.asset('assets/Image/photo.png'))
              ],
            ),
          ],
        );
      },
    );
  }
}
