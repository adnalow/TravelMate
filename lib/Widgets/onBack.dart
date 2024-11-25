import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // titlePadding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
      contentPadding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
      actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      // title: const Text(
      //   "Exit App",
      //   style: TextStyle(fontWeight: FontWeight.bold)
      // ),
      content: const Text(
        "Do you want to exit the app?",
        style: TextStyle(fontSize: 16),
        ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(fontSize: 16, color: Color(0xFF57CC99), fontWeight: FontWeight.w600),
            ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            "Confirm",
            style: TextStyle(fontSize: 16, color: Color(0xFF57CC99), fontWeight: FontWeight.w600),
            ),
        ),
      ],
    ),
  ) ??
  false; // Return false if dialog is dismissed
}
