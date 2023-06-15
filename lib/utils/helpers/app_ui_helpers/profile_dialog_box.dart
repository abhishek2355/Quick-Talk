import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Screens/view_profile.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;

class ViewProfileDialog extends StatelessWidget {
  const ViewProfileDialog({super.key, required this.user});
  final UserChat user;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor:  Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: media.height * app_heights.height400,
        child: Stack(
          children: [
            // Profile picture
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(media.height * app_heights.height150),
                child: CachedNetworkImage(
                  width: media.height * app_heights.height300,
                  height: media.height * app_heights.height300,
                  imageUrl: user.image,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),

            // Name of user
            Text(
              user.name,
              style: TextStyle(fontSize: media.height * app_heights.height20, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),

            // Information Icon
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewUserProfile(user: user),
                    ),
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue,
                  size: media.height * app_heights.height30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
