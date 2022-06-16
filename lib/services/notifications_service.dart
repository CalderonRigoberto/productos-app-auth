import 'package:flutter/material.dart';

class NotificationsService {
  static late GlobalKey<ScaffoldMessengerState> messageKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ));

    messageKey.currentState!.showSnackBar(snackBar);
  }
}
