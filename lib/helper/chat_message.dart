import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class MessageCard extends StatefulWidget {
  final Messages messages;
  const MessageCard({super.key, required this.messages});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    return (APIs.user.uid == widget.messages.fromId) ? _greenMessageCard() : _blueMessageCard();
  }

  // Another user messages
  Widget _blueMessageCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            padding: EdgeInsets.all(media.width * .04),
            margin: EdgeInsets.symmetric(horizontal: media.width * .04, vertical: media.height * .01),
            child: Text(
              widget.messages.msg,
              style: TextStyle(fontSize: media.height * 25 / 926, color: Colors.black),
            ),
          ),
        ),

        //  Show the time of message
        Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
          child: Text(
            widget.messages.sent,
            style: TextStyle(fontSize: media.height * 15 / 926, color: Colors.black45),
          ),
        )
      ],
    );
  }

  // Our messages
  Widget _greenMessageCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //  Show the time of message
        Row(
          children: [
            SizedBox(
              width: media.width * 0.04,
            ),
            Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: media.height * 20 / 926,
            ),
            SizedBox(
              width: media.width * 0.02,
            ),
            Text(
              widget.messages.read,
              style: TextStyle(fontSize: media.height * 15 / 926, color: Colors.black45),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
            padding: EdgeInsets.all(media.width * .04),
            margin: EdgeInsets.symmetric(horizontal: media.width * .04, vertical: media.height * .01),
            child: Text(
              widget.messages.msg,
              style: TextStyle(fontSize: media.height * 25 / 926, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
