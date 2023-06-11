import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/view_profile.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/my_date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Screens/chating_page.dart';
import '../../../main.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

class ChattingAppbar extends StatelessWidget {
  const ChattingAppbar({
    super.key,
    required this.widget,
  });

  final ChattingPage widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Move from chat screen to the Profile page
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewUserProfile(user: widget.user),
          )
        );
      },

      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => UserChat.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [

              // Back Button of Appbar
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: media.height * app_heights.height30,
                  color: Colors.black,
                ),
              ),

              // User profile image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(media.height * app_heights.height30),
                  child: CachedNetworkImage(
                    height: media.height * app_heights.height60,
                    width: media.height * app_heights.height60,
                    imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              // SizedBox with width 10
              SizedBox(
                width: media.width * app_widths.width20,
              ),

              // Username and last seen time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox with height 20
                  SizedBox(height: media.height * app_heights.height10,),
                  Row(
                    children: [
                      // User's Name
                      SizedBox(
                        width: media.width * app_widths.width190,
                        child: Text(
                          list.isNotEmpty ? list[0].name : widget.user.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: media.height * app_heights.height30),
                        ),
                      ),
                      
                      // Video call Icon
                      SizedBox(
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset('${app_strings.imagePath}video.png', height: media.height * app_heights.height18, width: media.height * app_heights.height30),
                        ),
                      ),

                      // SizedBox with width 16
                      SizedBox(width: media.width * 16 / 428,),

                      // Audio Call Icon
                      SizedBox(
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset('${app_strings.imagePath}audio_call.png', height: media.height * app_heights.height21, width: media.height * app_heights.height30),
                        ),
                      ),

                      // SizedBox with width 16
                      SizedBox(width: media.width * 12 / 428,),

                      // More Icon 
                      SizedBox(
                        child:InkWell(
                          onTap: (){},
                          child: Icon(Icons.more_vert_rounded,size: media.height * app_heights.height30),
                        )
                      )
                    ],
                  ),
                          
                  // SizedBox with height 2
                  SizedBox(height: media.height * app_heights.height2),
                          
                  // Last seen time 
                  Text(
                    list.isNotEmpty
                      ? list[0].isOnline
                          ? 'online'
                          : MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                      : MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: list.isNotEmpty
                      ? list[0].isOnline
                          ? TextStyle(color: Colors.green, fontSize: media.height * app_heights.height18)
                          : TextStyle(color: Colors.black54, fontSize: media.height * app_heights.height18)
                      : TextStyle(color: Colors.black54, fontSize: media.height * app_heights.height18),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
