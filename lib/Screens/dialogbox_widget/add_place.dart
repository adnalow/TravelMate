import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/discover_utils/utils.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';
import 'package:travel_mate/discover_utils/services/db_service.dart';
import 'package:travel_mate/service/user_service.dart';

Future<void> showUploadDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  bool isUploading = false; // Track upload state

  final DatabaseService _databaseService = DatabaseService();
  final UserService _userService = UserService();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
            contentPadding: const EdgeInsets.all(15),
            actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Upload Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close_sharp),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image = await getImageFromGallery(context);
                      if (image != null) {
                        setState(() {
                          selectedImage = image; // Update the selectedImage
                        });
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 250,
                      color: Colors.grey[200],
                      child: selectedImage != null
                          ? Image.file(selectedImage!, fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: nameController,
                    hintText: 'Name',
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                  ),
                ),
              ),
              reusableElevatedButton(
                text: isUploading ? 'Uploading...' : 'Upload',
                onPressed: isUploading
                    ? null // Disable button while uploading
                    : () async {
                        setState(() {
                          isUploading = true; // Disable button immediately
                        });

                        try {
                          if (selectedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image to upload.'),
                              ),
                            );
                            return;
                          }

                          // Upload the selected image and get the download URL
                          String? imageUrl = await uploadFileForUser(selectedImage!);
                          String primaryId = generateId(10);

                          final String email = FirebaseAuth.instance.currentUser?.email ?? '';
                          final String? userId = await _userService.fetchUserIdByEmail(email);

                          if (imageUrl != null && userId != null) {
                            // Create a TravelmateDB object with image URL
                            TravelmateDB travelmateDB = TravelmateDB(
                              description: descriptionController.text,
                              id: primaryId,
                              name: nameController.text,
                              image_url: imageUrl,
                              userId: userId,
                            );

                            await _databaseService.addFeaturedPlace(travelmateDB);

                            // Optionally, clear fields and close dialog
                            Navigator.of(context).pop();
                            descriptionController.clear();
                            nameController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to upload image.'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error during upload: $e'),
                            ),
                          );
                        } finally {
                          setState(() {
                            isUploading = false; // Reset state for future uploads
                          });
                        }
                      },
              ),
            ],
          );
        },
      );
    },
  );
}