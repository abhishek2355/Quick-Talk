import 'package:flutter/material.dart';

class ProfileChangeTextField extends StatelessWidget {
  const ProfileChangeTextField({
    super.key,
    required this.userprofileinfo,
    required this.hintText,
    required this.lableText,
    required this.onSaveInfo,
  });

  final String userprofileinfo;
  final String hintText;
  final String lableText;
  final dynamic onSaveInfo;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      // Initial value
      initialValue: userprofileinfo,
      // What to save
      onSaved: onSaveInfo,
      // Validate the entered value
      validator: (val) => (val != null && val.isNotEmpty) ? null : 'Enter Something',

      style: TextStyle(fontSize: media.height * 25 / 926),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: media.height * 10 / 926),
        prefixIcon: Icon(
          Icons.person,
          size: media.height * 25 / 926,
          color: Colors.blue,
        ),
        hintText: hintText,
        label: Text(lableText),
      ),
    );
  }
}
