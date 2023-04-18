import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/material.dart';

import '../helper/chat_input.dart';
import '../helper/chattingpage_appbar.dart';

class ChattingPage extends StatefulWidget {
  final UserChat user;
  const ChattingPage({super.key, required this.user});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
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
          body: Column(
            children: const [ChatInput()],
          )),
    );
  }
}
