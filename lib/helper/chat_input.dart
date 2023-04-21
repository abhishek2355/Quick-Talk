import 'package:chat_app/api/apis.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/chat_user.dart';

class ChatInput extends StatelessWidget {
  final textController;
  final UserChat user;
  const ChatInput({
    super.key,
    this.textController,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: media.height * 0.01, horizontal: media.height * 0.001),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: media.height * 30 / 926,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      maxLines: null,
                      style: TextStyle(fontSize: media.height * 25 / 926),
                      decoration: const InputDecoration(hintText: 'Type Something...', hintStyle: TextStyle(color: Colors.black45), border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: media.height * 30 / 926,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: media.height * 30 / 926,
                    ),
                  ),
                  SizedBox(
                    width: media.width * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            color: Colors.green,
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                EdgeInsets.only(top: media.height * 10 / 926, bottom: media.height * 10 / 926, left: media.height * 10 / 926, right: media.height * 5 / 926),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                APIs.sendMessage(user, textController.text);
                textController.text = '';
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: media.height * 35 / 926,
            ),
          )
        ],
      ),
    );
  }
}
