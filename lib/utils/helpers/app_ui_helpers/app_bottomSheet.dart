import 'package:flutter/material.dart';

class OptionItemOfBottomSheet extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const OptionItemOfBottomSheet({super.key, required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 16 / 428),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: media.width * 10 / 428,
            ),
            Flexible(
              child: Text(
                name,
                style: TextStyle(fontSize: media.height * 20 / 926),
              ),
            ),
            SizedBox(
              height: media.height * 60 / 926,
            ),
          ],
        ),
      ),
    );
  }
}
