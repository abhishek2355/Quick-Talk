import 'dart:io';

import 'package:chat_app/helper/chat_message.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/chattingpage_appbar.dart';
import '../model/message.dart';

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

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(media.height * 70 / 926),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: ChattingAppbar(widget: widget),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 221, 236, 248),
              body: Column(
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
                                reverse: false,
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
                                  "Say Hii 👋",
                                  style: TextStyle(fontSize: media.height * 25 / 926, letterSpacing: 2),
                                ),
                              );
                            }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: media.height * 0.01, horizontal: media.height * 0.001),
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
                                    size: media.height * 30 / 926,
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
                                    style: TextStyle(fontSize: media.height * 25 / 926),
                                    decoration: const InputDecoration(
                                        hintText: 'Type Something...', hintStyle: TextStyle(color: Colors.black45), border: InputBorder.none),
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
                          padding: EdgeInsets.only(
                              top: media.height * 10 / 926, bottom: media.height * 10 / 926, left: media.height * 10 / 926, right: media.height * 5 / 926),
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              APIs.sendMessage(widget.user, textController.text);
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
                  ),
                  if (isShowEmoji)
                    SizedBox(
                      height: media.height * 300 / 926,
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
              )),
        ),
      ),
    );
  }
}
