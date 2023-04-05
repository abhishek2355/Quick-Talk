import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final UserChat user;

  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    // import list

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue[50],
      elevation: 1,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // User profile picture
          leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),

          // User name
          title: Text(widget.user.name),

          // last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          // last message time
          trailing: const Text(
            '12:00 am',
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
