import 'package:flutter/material.dart';
import 'package:chat_app/utils/constants/app_strings.dart' as app_strings;

class LoginIcons extends StatelessWidget {
  final String imageName;
  final VoidCallback onTap;
  const LoginIcons({
    super.key,
    required this.imageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
        onTap: onTap,
        child: Image.asset(
          app_strings.imagePath + imageName,
          height: media.height * 40 / 926,
          width: media.height * 40 / 926,
        ));
  }
}
