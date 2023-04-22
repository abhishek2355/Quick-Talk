import 'package:flutter/material.dart';

class MessageSendTime {
  static String getTimeOfMessages({required BuildContext context, required String time}) {
    final messagesSentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(messagesSentTime).format(context);
  }
}
