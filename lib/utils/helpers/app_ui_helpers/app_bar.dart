import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget {
  final String appBarText;
  const ApplicationBar({
    super.key,
    required this.appBarText,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(230, 255, 255, 255),
      elevation: 7,
      centerTitle: true,
      title: Text(
        appBarText,
        style: TextStyle(fontSize: media.height * 24 / 926, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
