import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';
import '../../helper/send_time.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

class MessageCard extends StatefulWidget {
  final Messages messages;
  const MessageCard({super.key, required this.messages});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override

  // reciver and sender messages
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return (APIs.user.uid == widget.messages.fromId) ? _greenMessageCard() : _blueMessageCard();
  }

  // Another user messages
  Widget _blueMessageCard() {
    if (widget.messages.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.messages);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            padding: EdgeInsets.all(media.height * app_heights.height25),
            margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16, vertical: media.height * app_heights.height10),
            child: Text(
              widget.messages.msg,
              style: TextStyle(fontSize: media.height * app_heights.height25, color: Colors.black),
            ),
          ),
        ),

        //  Show the time of message
        Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16),
          child: Text(
            MessageSendTime.getTimeOfMessages(context: context, time: widget.messages.sent),
            style: TextStyle(fontSize: media.height * app_heights.height15, color: Colors.white),
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
              width: media.width * app_widths.width10,
            ),

            // If message is read then it will work
            (widget.messages.read.isNotEmpty)
                ? Icon(
                    Icons.done_all_rounded,
                    color: Colors.blue,
                    size: media.height * app_heights.height20,
                  )
                : Icon(
                    Icons.done_all_rounded,
                    color: Colors.grey,
                    size: media.height * app_heights.height20,
                  ),

            // SizedBox
            SizedBox(
              width: media.width * app_widths.width10,
            ),

            // Sending Time
            Text(
              MessageSendTime.getTimeOfMessages(context: context, time: widget.messages.sent),
              style: TextStyle(fontSize: media.height * app_heights.height15, color: Colors.white),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.pink[50],
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
            padding: EdgeInsets.all(media.height * app_heights.height25),
            margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width10, vertical: media.height * app_heights.height10),
            child: Text(
              widget.messages.msg,
              style: TextStyle(fontSize: media.height * app_heights.height25, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
