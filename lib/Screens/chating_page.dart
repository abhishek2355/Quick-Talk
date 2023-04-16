import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: ChattingAppbar(widget: widget),
        ),
      ),
    );
  }
}
