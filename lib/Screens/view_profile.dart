import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_heights.dart' as app_heights;

class ViewUserProfile extends StatefulWidget {
  final UserChat user;
  const ViewUserProfile({super.key, required this.user});

  @override
  State<ViewUserProfile> createState() => _ViewUserProfile();
}

class _ViewUserProfile extends State<ViewUserProfile> {
  @override
  Widget build(BuildContext context) {
    // MediaQuery veriable
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              color:const Color.fromARGB(255, 246, 246, 235),
              height: media.height,
              width: media.width,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: media.height * 60 / 926,),
                          
                      ClipRRect(
                        borderRadius: BorderRadius.circular(media.height * app_heights.height100),
                        child: CachedNetworkImage(
                          height: media.height * 200 / 926,
                          width: media.height * 200 / 926,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                
                      SizedBox(
                        height: media.height * 20 / 926,
                      ),
                
                      Text(
                        widget.user.name,
                        style: TextStyle(fontSize: media.height * 35 / 926, fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                          
                      SizedBox(
                        height: media.height * 8 / 926,
                      ),
                          
                      Text(
                        widget.user.email,
                        style: TextStyle(fontSize: media.height * 20 / 926, color: Colors.black54),
                      ),
                          
                      SizedBox(height: media.height * 90 / 926,),
                          
                      SizedBox(
                        height: media.height * 150 / 926,
                        child: Row(
                          children: [
                          
                            Expanded(
                              child: InkWell(
                                onTap: (){Navigator.pop(context);},
                                child: Icon(Icons.chat_outlined,color: Colors.blue,size: media.height * 60 / 926,),
                              ),
                            ),
                          
                            const VerticalDivider(color: Colors.grey),
                          
                            Expanded(
                              child: InkWell(
                                onTap: (){},
                                child: Icon(Icons.video_call_outlined,color: Colors.blue,size: media.height * 60 / 926,),
                              ),
                            )
                          ],
                        ),
                      ),
              
                      SizedBox(height: media.height * 40 / 926,),
              
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.person_circle,size: media.height * 40 / 926,color: Colors.black54),
                              SizedBox(width: media.width * 10  / 428,),
                              Text('View Friends' , style: TextStyle(fontSize: media.height * 25 / 926),)
                            ],
                          ),
              
                          SizedBox(height: media.height * 10 / 926,),
              
                          Row(
                            children: [
                              Icon(CupertinoIcons.heart,size: media.height * 40 / 926,color: Colors.black54),
                              SizedBox(width: media.width * 10  / 428,),
                              Text('Add to Favorite',style: TextStyle(fontSize: media.height * 25 / 926))
                            ],
                          )
                        ],
                      )
                    ],
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
