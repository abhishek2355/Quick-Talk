import 'package:flutter/material.dart';

class TextFormFields extends StatefulWidget {
  final String hintText;
  final String labelText;
  final IconData iconName;
  final bool isPasswordTextField;
  const TextFormFields({
    super.key,
    required this.hintText,
    required this.iconName,
    required this.isPasswordTextField,
    required this.labelText,
  });

  @override
  State<TextFormFields> createState() => _TextFormFieldsState();
}

class _TextFormFieldsState extends State<TextFormFields> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    void toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    if (widget.isPasswordTextField == true) {
      return SizedBox(
        height: media.height * 60 / 926,
        child: TextFormField(
          obscureText: _obscureText,
          style: TextStyle(fontSize: media.height * 21 / 926),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.iconName, size: media.height * 25 / 926),
            suffixIcon: InkWell(
              child: _obscureText
                  ? Icon(
                      Icons.remove_red_eye,
                      size: media.height * 25 / 926,
                    )
                  : Icon(
                      Icons.visibility_off_rounded,
                      size: media.height * 25 / 926,
                    ),
              onTap: () {
                toggle();
              },
            ),
            hintText: widget.hintText,
            labelText: widget.labelText,
            contentPadding: EdgeInsets.symmetric(horizontal: media.width * 16 / 926),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: media.height * 60 / 926,
        child: TextFormField(
          style: TextStyle(fontSize: media.height * 21 / 926),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.iconName, size: media.height * 25 / 926),
            hintText: widget.hintText,
            labelText: widget.labelText,
            contentPadding: EdgeInsets.symmetric(horizontal: media.width * 16 / 926),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      );
    }
  }
}
