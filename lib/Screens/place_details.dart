import 'package:flutter/material.dart';
import 'package:travel_mate/Screens/dialogbox_widget/add_review.dart';
import 'package:travel_mate/Screens/explore.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/main_screen.dart';
import 'review_list.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:iconsax/iconsax.dart';
import 'package:travel_mate/controllers/tabtab_controller.dart';

class DetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String? imageUrl;
  final String id;

  const DetailPage({
    super.key,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // Get the instance of TabtabController
    final TabtabController tabController = Get.find<TabtabController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(
              color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Iconsax.arrow_left_2,
                color: Color(0xFFFFFFFF), size: 28),
            onPressed: () {
              // Use GetX to update the tab and navigate back to MainScreen
              final TabtabController tabController =
                  Get.find<TabtabController>();
              tabController.selectIndex(4); // Index 4 for Discover tab

              // Navigate back to MainScreen while preserving bottom navigation
              Get.off(() => const MainScreen());
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    height: 400,
                    width: double.infinity,
                  )
                else
                  const Icon(
                    Icons.image_not_supported,
                    size: 350,
                    color: Colors.grey,
                  ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: Color(0xFFFFFFFF),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF808080)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  color: const Color(0xffFFFFFF),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const Divider(thickness: 0.5),
                      ReviewList(documentId: id),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 45,
              child: reusableElevatedButton(
                text: 'Write a review',
                onPressed: () async {
                  if (id.isNotEmpty) {
                    await reviewDialog(context, id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("No valid document found to add a review."),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
