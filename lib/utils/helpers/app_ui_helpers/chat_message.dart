import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_bottomSheet.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_dialogbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/message.dart';
import '../../../helper/send_time.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

import 'my_date_utils.dart';

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
    bool isMe = APIs.user.uid == widget.messages.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: (isMe) ? _greenMessageCard() : _blueMessageCard(),
    );
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
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            padding: EdgeInsets.all((widget.messages.type == Type.text) ? media.height * app_heights.height20 : media.height * app_heights.height10),
            margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16, vertical: media.height * app_heights.height10),
            child: (widget.messages.type == Type.text)
                ? Text(
                    widget.messages.msg,
                    style: TextStyle(fontSize: media.height * app_heights.height25, color: Colors.black),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(media.height * app_heights.height30),
                    child: CachedNetworkImage(
                        imageUrl: widget.messages.msg,
                        placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: media.height * app_heights.height70,
                              color: Colors.blue,
                            )),
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
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
          padding: EdgeInsets.all(widget.messages.type == Type.text ? media.height * app_heights.height20 : media.height * app_heights.height10),
          margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width10, vertical: media.height * app_heights.height10),
          child: widget.messages.type == Type.text
              ? Text(
                  widget.messages.msg,
                  style: TextStyle(fontSize: media.height * app_heights.height25, color: Colors.black),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(media.height * app_heights.height30),
                  child: CachedNetworkImage(
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: media.height * app_heights.height70,
                            color: Colors.blue,
                          )),
                ),
        )),
      ],
    );
  }

// Bottom Sheet Bar
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 152, 218, 248),
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: media.height * app_heights.height30, bottom: media.height * app_heights.height30),
          shrinkWrap: true,
          children: [
            // Black Divider
            Container(
              height: media.height * 4 / 926,
              margin: EdgeInsets.symmetric(horizontal: media.width * 160 / 428),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
            ),

            // Copy Option
            widget.messages.type == Type.text
                ? OptionItemOfBottomSheet(
                    icon: Icon(
                      Icons.copy_all_rounded,
                      color: Colors.black,
                      size: media.height * 30 / 926,
                    ),
                    name: 'Copy',
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: widget.messages.msg)).then((value) {
                        // For close the bottomsheet
                        Navigator.pop(context);
                      });
                    },
                  )
                : OptionItemOfBottomSheet(
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.black,
                      size: media.height * 30 / 926,
                    ),
                    name: 'Save Image',
                    onTap: () {},
                  ),

            Divider(
              color: Colors.black,
              endIndent: media.width * 16 / 428,
              indent: media.width * 16 / 428,
            ),

            // Delete Option
            if (isMe)
              OptionItemOfBottomSheet(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: media.height * 30 / 926,
                ),
                name: 'Delete',
                onTap: () {
                  APIs.deleteMessage(widget.messages).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),

            if (isMe)
              Divider(
                color: Colors.black,
                endIndent: media.width * 16 / 428,
                indent: media.width * 16 / 428,
              ),

            // Send time
            OptionItemOfBottomSheet(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
                size: media.height * 30 / 926,
              ),
              name: 'Sent at: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.sent)}',
              onTap: () {},
            ),

            // Read time
            OptionItemOfBottomSheet(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
                size: media.height * 30 / 926,
              ),
              name: widget.messages.read.isEmpty
                  ? 'Read at: Not available yet'
                  : 'Read at: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.sent)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}
