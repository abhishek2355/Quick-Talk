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

class ChattingAppbar extends StatelessWidget {
  const ChattingAppbar({
    super.key,
    required this.widget,
  });

  final ChattingPage widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewUserProfile(user: widget.user),
            ));
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => UserChat.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: media.height * app_heights.height23,
                ),
              ),

              // User profile image
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16),
                child: Center(
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
              ),

              // SizedBox with width 10
              SizedBox(
                width: media.width * app_widths.width10,
              ),

              // Username and last seen time
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: media.height * app_heights.height25),
                    ),

                    // SizedBox with height 2
                    SizedBox(height: media.height * app_heights.height2),

                    // Last seen of user
                    Expanded(
                      child: Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'online'
                                : MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                        style: TextStyle(color: Colors.black54, fontSize: media.height * 18 / 926),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
