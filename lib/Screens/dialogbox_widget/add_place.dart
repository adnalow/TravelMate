import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travel_mate/discover_utils/utils.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';
import 'package:travel_mate/discover_utils/services/db_service.dart';

Future<void> showUploadDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;

  final DatabaseService _databaseService = DatabaseService();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Upload Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final image = await getImageFromGallery(context);
                  if (image != null) {
                    selectedImage = image; // Update the selectedImage
                    (context as Element)
                        .markNeedsBuild(); // Rebuild dialog to display selected image
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo, size: 50),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedImage != null) {
                // Upload the selected image and get the download URL
                String? imageUrl = await uploadFileForUser(selectedImage!);
                String primaryId = generateId(10);
                if (imageUrl != null) {
                  // Create a TravelmateDB object with image URL
                  TravelmateDB travelmateDB = TravelmateDB(
                    description: descriptionController.text,
                    id: primaryId,
                    name: nameController.text,
                    image_url: imageUrl,
                  );

                  await _databaseService.addFeaturedPlace(travelmateDB);

                  // Optionally, clear fields and close dialog
                  Navigator.of(context).pop();
                  descriptionController.clear();
                  nameController.clear();
                } else {
                  print("Failed to upload image.");
                }
              } else {
                print("Please select an image to upload.");
              }
            },
            child: const Text('Upload'),
          ),
        ],
      );
    },
  );
}
