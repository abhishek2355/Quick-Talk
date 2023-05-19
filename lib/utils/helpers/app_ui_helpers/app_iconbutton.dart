import 'package:flutter/material.dart';

import '../../../api/apis.dart';
import 'app_dialogbar.dart';

class IconsWithButton extends StatelessWidget {
  const IconsWithButton({
    super.key,
    required GlobalKey<FormState> formkey,
    required this.buttonIcon,
    required this.buttonText,
  }) : _formkey = formkey;

  final IconData buttonIcon;
  final String buttonText;
  final GlobalKey<FormState> _formkey;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height * 50 / 926,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            // For save the new information
            _formkey.currentState!.save();

            // update the informatio on firebase
            APIs.updatedUserInformation();

            // Show the Snackbar of updated profile
            Dialogs.showSnackbar(context, 'Profile Successfully Updated');
          }
        },
        icon: Icon(
          buttonIcon,
          size: media.height * 25 / 926,
        ),
        label: Text(
          buttonText,
          style: TextStyle(fontSize: media.height * 25 / 926),
        ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: Size(media.width * .5, media.height * 0.06),
        ),
      ),
    );
  }
}
