import 'package:cached_network_image/cached_network_image.dart';
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
      onTap: () {},
      child: Row(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(media.height * app_heights.height30),
                child: CachedNetworkImage(
                  height: media.height * app_heights.height60,
                  width: media.height * app_heights.height60,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: media.width * app_widths.width10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: media.height * app_heights.height25),
                ),
                SizedBox(height: media.height * app_heights.height2),
                Text(
                  'Last seen not available now!',
                  style: TextStyle(color: Colors.black54, fontSize: media.height * app_heights.height20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
