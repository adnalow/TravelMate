import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Exit App"),
      content: const Text("Do you want to exit the app?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Confirm"),
        ),
      ],
    ),
  ) ??
  false; // Return false if dialog is dismissed
}
