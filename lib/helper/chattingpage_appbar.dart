import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/chating_page.dart';
import '../main.dart';

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
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back,
                size: media.height * 23 / 926,
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(media.height * 30 / 926),
                child: CachedNetworkImage(
                  height: media.height * 60 / 926,
                  width: media.height * 60 / 926,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: media.width * 10 / 428,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: media.height * 25 / 926),
              ),
              SizedBox(height: media.height * 2 / 926),
              Text(
                'Last seen not available now!',
                style: TextStyle(color: Colors.black54, fontSize: media.height * 20 / 926),
              )
            ],
          )
        ],
      ),
    );
  }
}
