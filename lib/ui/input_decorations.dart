import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
   required String hintText,
   required String labelText,
   IconData? icon
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon:
            Icon(icon, color: Colors.deepPurple));
  }
}
