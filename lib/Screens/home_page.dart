import 'package:chat_app/Screens/profile_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
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
  // For storing all users
  List<UserChat> _list = [];

  // For storing serched user
  final List<UserChat> _searchlist = [];

  // For storing search
  bool _isSearch = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    // Gesture detection is for close the keybord when we tap anywhere in the screen
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearch) {
            setState(() {
              _isSearch = !_isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          // App Bar
          appBar: AppBar(
            // Home Icon
            leading: Icon(CupertinoIcons.home, size: media.height * 28 / 926),

            // App Text
            title: (_isSearch)
                ? TextFormField(
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Name or email'),
                    autofocus: true,
                    style: TextStyle(fontSize: media.height * 25 / 926, letterSpacing: 0.5),

                    // When search text is entered then update the search list
                    onChanged: (val) {
                      // search logic
                      _searchlist.clear();

                      // Iterate the main list
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) || (i.email.toLowerCase().contains(val.toLowerCase()))) {
                          _searchlist.add(i);
                        }
                        setState(() {
                          _searchlist;
                        });
                      }
                    },
                  )
                : Text(
                    "We Chat",
                    style: TextStyle(fontSize: media.height * 28 / 926),
                  ),

            actions: [
              // Search Icon
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearch = !_isSearch;
                  });
                },
                icon: (_isSearch)
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : Icon(
                        Icons.search,
                        size: media.height * 35 / 926,
                      ),
              ),

              // Profile icons
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(user: APIs.me),
                      ),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.blue,
                    size: media.height * 35 / 926,
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
            stream: APIs.getAllUsers(),
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
                    _list = data?.map((e) => UserChat.fromJson(e.data())).toList() ?? [];
                  }

                  if (_list.isNotEmpty) {
                    // return listview
                    return ListView.builder(
                      itemBuilder: ((context, index) {
                        return ChatUserCard(
                          // if we search then search list will show
                          user: (_isSearch) ? _searchlist[index] : _list[index],
                        );
                        // return Text("Name: ${list[index]}");
                      }),

                      // If we search user then count will be searchlist count otherwise main list count
                      itemCount: (_isSearch) ? _searchlist.length : _list.length,
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
        ),
      ),
    );
  }
}
