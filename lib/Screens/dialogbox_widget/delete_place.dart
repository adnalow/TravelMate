import 'package:flutter/material.dart';
import 'package:travel_mate/discover_utils/services/db_service.dart';

Future<void> showDeleteDialog(BuildContext context, String placeId) async {
  final DatabaseService _databaseService = DatabaseService();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Do you want to delete the featured place?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              print(placeId);
              _databaseService.deleteFeaturedPlace(placeId);
              Navigator.of(context).pop(); // Close the dialog after deletion
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}
