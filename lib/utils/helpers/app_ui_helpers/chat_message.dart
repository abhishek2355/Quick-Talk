import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/app_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/message.dart';
import '../../../helper/send_time.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;

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
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.all((widget.messages.type == Type.text) ? media.height * app_heights.height20 : media.height * app_heights.height10),
            margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16, vertical: media.height * app_heights.height10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message of text and image
                (widget.messages.type == Type.text)
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
                        )
                      ),
                    ),

                // SizedBox with height 10
                SizedBox(
                  height: media.height * app_heights.height10,
                ),

                //  Show the time of message
                Text(
                  MessageSendTime.getTimeOfMessages(context: context, time: widget.messages.sent),
                  style: TextStyle(fontSize: media.height * app_heights.height15, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: media.width * app_widths.width89,
        ),
      ],
    );
  }

  // Our messages
  Widget _greenMessageCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // SizedBox with width 90
        SizedBox(
          width: media.width * app_widths.width89,
        ),

        // Message Container
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
            padding: EdgeInsets.all(widget.messages.type == Type.text ? media.height * app_heights.height20 : media.height * app_heights.height10),
            margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width10, vertical: media.height * app_heights.height10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text or image
                Container(
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
                ),

                // Sizedbox with height 10
                SizedBox(
                  height: media.height * app_heights.height10,
                ),

                // Message time and message read tik
                SizedBox(
                  width: media.width * app_widths.width80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Sending Time
                      Text(
                        MessageSendTime.getTimeOfMessages(context: context, time: widget.messages.sent),
                        style: TextStyle(fontSize: media.height * app_heights.height15, color: Colors.black),
                      ),

                      // SizedBox with width 10
                      SizedBox(
                        width: media.width * app_widths.width2,
                      ),

                      // If message is read then it will work
                      (widget.messages.read.isNotEmpty)
                        ? Icon(
                            Icons.done_all_rounded,
                            color: Colors.purple,
                            size: media.height * app_heights.height20,
                          )
                        : Icon(
                            Icons.done_all_rounded,
                            color: Colors.white,
                            size: media.height * app_heights.height20,
                          ),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
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
              height: media.height * app_heights.height4,
              margin: EdgeInsets.symmetric(horizontal: media.width * app_widths.width160),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
            ),

            // Copy Option
            widget.messages.type == Type.text
              ? OptionItemOfBottomSheet(
                  icon: Icon(
                    Icons.copy_all_rounded,
                    color: Colors.black,
                    size: media.height * app_heights.height30,
                  ),
                  name: 'Copy',
                  onTap: () async {
                    if (mounted) {
                      await Clipboard.setData(ClipboardData(text: widget.messages.msg)).then((value) {
                        // For close the bottomsheet
                        Navigator.pop(context);
                      });
                    }
                  },
                )
              : OptionItemOfBottomSheet(
                  icon: Icon(
                    Icons.download_rounded,
                    color: Colors.black,
                    size: media.height * app_heights.height30,
                  ),
                  name: 'Save Image',
                  onTap: () {},
                ),
            
            // Divider 
            Divider(
              color: Colors.black,
              endIndent: media.width * app_widths.width16,
              indent: media.width * app_widths.width16,
            ),

            // Delete Option
            if (isMe)
              OptionItemOfBottomSheet(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: media.height * app_heights.height30,
                ),
                name: 'Delete',
                onTap: () {
                  APIs.deleteMessage(widget.messages).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),

            // Divider 
            if (isMe)
              Divider(
                color: Colors.black,
                endIndent: media.width * app_widths.width16,
                indent: media.width * app_widths.width16,
              ),

            // Send time
            OptionItemOfBottomSheet(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
                size: media.height * app_heights.height30,
              ),
              name: 'Sent at: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.sent)}',
              onTap: () {},
            ),

            // Read time
            OptionItemOfBottomSheet(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
                size: media.height * app_heights.height30,
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
