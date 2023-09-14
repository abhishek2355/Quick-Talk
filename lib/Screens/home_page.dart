import 'package:chat_app/Screens/profile_page.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/helpers/app_ui_helpers/user_chat_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/chat_user.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;
import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;

class HomepageController extends GetxController{
  // For search engin
  RxBool isSearch = false.obs;
  // Update isSearch
  updateIsSearchValue(){
    isSearch.value = !isSearch.value;
  }
  // For store the search user's in list
  RxList searchlist = [].obs;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomepageController _homePageController;
  // For storing all users
  List<UserChat> _list = [];

  @override
  void initState() {
    super.initState();
    // initialize the getx controller
    _homePageController = HomepageController();
    // Get self infomation
    APIs.getSelfInfo();
    // For showing status online or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
        if (message.toString().contains('pause')) APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  void dispose(){
    // Dispose of the controller when the widget is disposed
    _homePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    // Gesture detection is for close the keybord when we tap anywhere in the screen
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_homePageController.isSearch.value) {
            _homePageController.updateIsSearchValue();
            return Future.value(false);
          } else {
            await APIs.updateActiveStatus(false);
            return Future.value(true);
          }
        },

        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              // AppBar
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(media.height * app_heights.height80),
                child: AppBar(
                  backgroundColor: Colors.white,
                  // App Text
                  title: Obx(() {
                    return (_homePageController.isSearch.value)
                      ? TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: app_strings.homepageSearchbarText,
                            hintStyle: TextStyle(color: Colors.black, fontSize: media.height * app_heights.height22),
                          ),
                          autofocus: true,
                          style: TextStyle(fontSize: media.height * app_heights.height25, letterSpacing: 0.5),
        
                          // When search text is entered then update the search list
                          onChanged: (val) {
                            _homePageController.searchlist.clear();
        
                            // Iterate the main list
                            for (var i in _list) {
                              if (i.name.toLowerCase().contains(val.toLowerCase()) || (i.email.toLowerCase().contains(val.toLowerCase()))) {
                                _homePageController.searchlist.add(i);
                              }
                              _homePageController.searchlist;
                            }
                          },
                        )
                      : Text(
                          app_strings.appName,
                          style: TextStyle(fontSize: media.height * app_heights.height28, color: Colors.black, fontWeight: FontWeight.bold),
                        );
                    }
                  ),
        
                  actions: [
                    // Search Icon
                    IconButton(
                      onPressed: () {
                        _homePageController.updateIsSearchValue();
                      },
                      icon: Obx(() {
                        return (_homePageController.isSearch.value)
                          ? Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: Colors.black,
                              size: media.height * app_heights.height35,
                            )
                          : Icon(
                              Icons.search,
                              size: media.height * app_heights.height35,
                              color: Colors.black,
                            );
                        }
                      )
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
                        color: Colors.black,
                        size: media.height * app_heights.height35,
                      ),
                    ),
                  ],
                ),
              ),
        
              // Body of the project
              body: Center(
                child: Container(
                  height: media.height,
                  width: media.width,
                  alignment: Alignment.center,
                  color:const Color.fromARGB(255, 246, 246, 235),
                  
                  // Login users profile
                  child: StreamBuilder(
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
                            return Obx(() {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: ((context, index){
                                  return ChatUserCard(
                                    // if we search then search list will show
                                    user: (_homePageController.isSearch.value) ? _homePageController.searchlist[index] : _list[index],
                                  );
                                }),
                                // If we search user then count will be searchlist count otherwise main list count
                                itemCount: (_homePageController.isSearch.value) ? _homePageController.searchlist.length : _list.length,
                              );
                            });
                          } else {
                            return Center(
                              child: Text(
                                app_strings.homePageNoAnyConnection,
                                style: TextStyle(fontSize: media.height * app_heights.height25, letterSpacing: 2),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
