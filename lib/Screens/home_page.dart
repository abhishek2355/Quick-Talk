import 'package:chat_app/Screens/profile_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/widgets/user_chat_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/chat_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserChat> list = [];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      // App Bar
      appBar: AppBar(
        // Home Icon
        leading: Icon(CupertinoIcons.home, size: media.height * 28 / 926),

        // App Text
        title: Text(
          "We Chat",
          style: TextStyle(fontSize: media.height * 28 / 926),
        ),

        actions: [
          // Search Icon
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: media.height * 28 / 926,
              )),

          // More icons
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(user: list[0]),
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert,
                size: media.height * 28 / 926,
              ))
        ],
      ),

      // floating Action Button for add new user
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_comment_rounded)),

      // Body of the project
      body: StreamBuilder(
        stream: APIs.firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );

            // If some or all data is loading
            case ConnectionState.active:
            case ConnectionState.done:

              // If data is there
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                list = data?.map((e) => UserChat.fromJson(e.data())).toList() ?? [];
              }

              if (list.isNotEmpty) {
                // return listview
                return ListView.builder(
                  itemBuilder: ((context, index) {
                    return ChatUserCard(
                      user: list[index],
                    );
                    // return Text("Name: ${list[index]}");
                  }),
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                );
              } else {
                return Center(
                    child: Text(
                  "No Connection Found",
                  style: TextStyle(fontSize: media.height * 25 / 926, letterSpacing: 2),
                ));
              }
          }
        },
      ),
    );
  }
}
