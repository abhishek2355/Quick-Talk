import 'package:chat_app/helper/chat_message.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/chat_input.dart';
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

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    return SafeArea(
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
              ChatInput(
                textController: textController,
                user: widget.user,
              )
            ],
          )),
    );
  }
}
