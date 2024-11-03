import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/Screens/dialogbox_widget/add_place.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';
import 'package:travel_mate/discover_utils/services/db_service.dart';
import 'package:travel_mate/Screens/place_details.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Featured Destinations'),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _databaseService.getFeaturedPlaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  snapshot.data!.docs.every((doc) =>
                      (doc.data())['name'] == null ||
                      (doc.data())['name'].toString().isEmpty)) {
                return const Center(child: Text("No items to display."));
              }

              final featuredPlaces = snapshot.data!.docs.map((doc) {
                return TravelmateDB.fromJson(doc.data());
              }).toList();

              return GridView.builder(
                padding: const EdgeInsets.only(
                    top: 10, right: 10, bottom: 65, left: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.80,
                ),
                itemCount: featuredPlaces.length,
                itemBuilder: (BuildContext context, int index) {
                  final place = featuredPlaces[index];

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('reviews')
                        .where('id', isEqualTo: place.id)
                        .get(),
                    builder: (context, reviewSnapshot) {
                      int reviewCount = 0;
                      if (reviewSnapshot.hasData) {
                        reviewCount = reviewSnapshot.data!.docs.length;
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                name: place.name,
                                description: place.description,
                                imageUrl: place.image_url,
                                id: place.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(5),
                                  ),
                                  child: place.image_url != null
                                      ? Image.network(
                                          place.image_url,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      place.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Reviews ($reviewCount)',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 40,
            right: 40,
            child: reusableElevatedButton(
              text: 'Feature your place here!',
              onPressed: () {
                showUploadDialog(context); // Use the dialog you already created
              },
            ),
          ),
        ],
      ),
    );
  }
}
