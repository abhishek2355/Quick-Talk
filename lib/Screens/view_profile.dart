import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

class ViewUserProfile extends StatefulWidget {
  final UserChat user;
  const ViewUserProfile({super.key, required this.user});

  @override
  State<ViewUserProfile> createState() => _ViewUserProfile();
}

class _ViewUserProfile extends State<ViewUserProfile> {
  @override
  Widget build(BuildContext context) {
    // MediaQuery veriable
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: SafeArea(
        child: Scaffold(
          // Body of the project

          body: Column(
            children: [
              Container(
                height: media.height * 300 / 926,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
                  child: Column(
                    children: [
                      // Navigationbar for user video call and audio call
                      SizedBox(
                        height: media.height * 50 / 926,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: media.height * 30 / 926,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: media.width * 180 / 428,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Image.asset('${app_strings.imagePath}video.png', height: media.height * 30 / 926, width: media.height * 30 / 926),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Image.asset('${app_strings.imagePath}audio_call.png', height: media.height * 30 / 926, width: media.height * 30 / 926),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // SizedBox with height 60
                      SizedBox(
                        height: media.height * 60 / 926,
                      ),

                      // Users profile picture and name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(media.height * app_heights.height90),
                            child: CachedNetworkImage(
                              height: media.height * 100 / 926,
                              width: media.height * 100 / 926,
                              fit: BoxFit.fill,
                              imageUrl: widget.user.image,
                              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                            ),
                          ),
                          SizedBox(
                            width: media.width * 20 / 428,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.name,
                                style: TextStyle(fontSize: media.height * 30 / 926, fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: media.height * 8 / 926,
                              ),
                              Text(
                                widget.user.email,
                                style: TextStyle(fontSize: media.height * 20 / 926, color: Colors.black54),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: media.height * 20 / 926,
              ),
              SizedBox(
                width: media.width,
                height: media.height * 500 / 926,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text(
                      'About',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: media.height * 20 / 926,
                    ),
                    Text(
                      widget.user.about,
                      style: const TextStyle(color: Colors.black54),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
