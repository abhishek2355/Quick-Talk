import 'dart:io';

import 'package:chat_app/model/chat_user.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../utils/helpers/app_ui_helpers/chat_message.dart';
import '../utils/helpers/app_ui_helpers/chattingpage_appbar.dart';
import '../model/message.dart';
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;
import 'package:chat_app/utils/constants/app_widths.dart' as app_widths;
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

class ChattingPage extends StatefulWidget {
  final UserChat user;
  const ChattingPage({super.key, required this.user});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  // For string all messages
  List<Messages> _list = [];

  // For handling messages text chnages
  final textController = TextEditingController();

  bool isShowEmoji = false;

  // For show progressbar indicator at the time of uploding images.
  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    // Variable of media Query
    var media = MediaQuery.of(context).size;

    // Body of the chat screen
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: WillPopScope(

            onWillPop: () {
              if (isShowEmoji) {
                setState(() {
                  isShowEmoji = !isShowEmoji;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },

            child: Scaffold(
              // Appbar of the chat screen
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(media.height * app_heights.height90),
                child: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  flexibleSpace: ChattingAppbar(widget: widget),
                ),
              ),

              // Body of the chatScreen
              body: Container(
                height: media.height,
                width: media.width,
                alignment: Alignment.center,
                color: const Color.fromARGB(255, 233, 233, 214),
                
                // Main Body of screen
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: APIs.getAllMessages(widget.user),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            // if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const SizedBox();

                            // If some or all data is loading
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];

                              if (_list.isNotEmpty) {
                                // return listview
                                return ListView.builder(
                                  itemCount: _list.length,
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    return MessageCard(
                                      messages: _list[index],
                                    );
                                  }),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    app_strings.chattingScreenNoConnectionText,
                                    style: TextStyle(fontSize: media.height * app_heights.height25, letterSpacing: 2),
                                  ),
                                );
                              }
                          }
                        },
                      ),
                    ),

                    if (isUploaded)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: media.width * app_widths.width16, vertical: media.height * 5 / 926),
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),

                    // input keybord
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: media.height * app_heights.height2, horizontal: media.width * app_widths.width2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        FocusScope.of(context).unfocus();
                                        isShowEmoji = !isShowEmoji;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.emoji_emotions,
                                      color: Colors.blueAccent,
                                      size: media.height * app_heights.height30,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: textController,
                                      maxLines: null,
                                      onTap: () {
                                        setState(() {
                                          if (isShowEmoji) {
                                            isShowEmoji = !isShowEmoji;
                                          }
                                        });
                                      },
                                      style: TextStyle(fontSize: media.height * app_heights.height25),
                                      decoration: const InputDecoration(
                                          hintText: app_strings.chattingScreenInputHintText,
                                          hintStyle: TextStyle(color: Colors.black45),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      // Pick an image.
                                      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
                                      if (images.isNotEmpty) {
                                        for (var i in images) {
                                          setState(() {
                                            isUploaded = true;
                                          });
                                          await APIs.sendChatImage(widget.user, File(i.path));
                                          setState(() {
                                            isUploaded = false;
                                          });
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.blueAccent,
                                      size: media.height * app_heights.height30,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      // Pick an image.
                                      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                                      if (image != null) {
                                        setState(() {
                                          isUploaded = true;
                                        });
                                        await APIs.sendChatImage(widget.user, File(image.path));
                                        setState(() {
                                          isUploaded = false;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.blueAccent,
                                      size: media.height * app_heights.height30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            minWidth: 0,
                            padding: EdgeInsets.only(
                                top: media.height * app_heights.height10,
                                bottom: media.height * app_heights.height10,
                                left: media.height * app_heights.height10,
                                right: media.height * app_heights.height5),
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                APIs.sendMessage(widget.user, textController.text, Type.text);
                                textController.text = '';
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: media.height * app_heights.height30,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (isShowEmoji)
                      SizedBox(
                        height: media.height * app_heights.height300,
                        child: EmojiPicker(
                          textEditingController: textController,
                          config: Config(
                            bgColor: const Color.fromARGB(255, 221, 236, 248),
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
