import 'package:chat_app/Screens/chating_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/profile_dialog_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

import 'my_date_utils.dart';

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
  //last message info
  Messages? _message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: media.height * app_heights.height100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width10),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: media.height * app_heights.height2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          elevation: 1,
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
              child: StreamBuilder(
                stream: APIs.getLastMessage(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final _list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
                  if (_list.isNotEmpty) _message = _list[0];
    
                  return Row(
                    children: [
                      // User profile icon
                      Padding(
                        padding: EdgeInsets.only(right: media.width * app_widths.width16),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            // When clicked on the profile picture then move to the Profile Page
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => ViewProfileDialog(
                                  user: widget.user,
                                )
                              );
                            },

                            // Profile picture of user
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
                            // user's name
                            Text(
                              widget.user.name,
                              maxLines: 1,
                              style: TextStyle(fontSize: media.height * app_heights.height24,fontWeight: FontWeight.w500),
                            ),

                            // SizedBox with height 5
                            SizedBox(
                              height: media.height * app_heights.height5,
                            ),

                            // Last message or about text
                            Text(
                              _message != null ? _message!.msg : widget.user.about,
                              maxLines: 1,
                              style: TextStyle(fontSize: media.height * app_heights.height18, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
    
                      // Last message time
                      Container(
                        alignment: Alignment.centerRight,
                        child: Center(
                          child: _message == null
                            ? null
                            : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                                ? Container(
                                    width: media.height * app_heights.height15,
                                    height: media.height * app_heights.height15,
                                    decoration: BoxDecoration(color: Colors.greenAccent.shade400, borderRadius: BorderRadius.circular(20)),
                                  )
                                : Text(
                                    MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                                    style: TextStyle(fontSize: media.height * app_heights.height18),
                                  ),
                        )
                      ),
                    ],
                  );
                },
              )
            ),
          ),
        ),
      ),
    );
  }
}
