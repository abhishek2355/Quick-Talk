import 'package:chat_app/Screens/chating_page.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/profile_dialog_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

class ChatUserCard extends StatefulWidget {
  final UserChat user;

  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: media.height * app_heights.height100,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          // Navigat to the chat screen
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingPage(user: widget.user),
              ),
            );
          },

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16),
            child: Row(
              children: [
                // User profile icon
                Padding(
                  padding: EdgeInsets.only(right: media.width * app_widths.width16),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => ViewProfileDialog(
                                  user: widget.user,
                                ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(media.height * app_heights.height30),
                        child: CachedNetworkImage(
                          height: media.height * app_heights.height60,
                          width: media.height * app_heights.height60,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // users name and about
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.name,
                        maxLines: 1,
                        style: TextStyle(fontSize: media.height * app_heights.height24),
                      ),
                      SizedBox(
                        height: media.height * app_heights.height5,
                      ),
                      Text(
                        widget.user.about,
                        maxLines: 1,
                        style: TextStyle(fontSize: media.height * app_heights.height18, color: Colors.black45),
                      ),
                    ],
                  ),
                ),

                // Last message time
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '12:00 am',
                    style: TextStyle(color: Colors.black45, fontSize: media.height * app_heights.height18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
