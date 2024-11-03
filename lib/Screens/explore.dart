import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Featured Destinations'),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 65, left: 10),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // maximum number of items per row
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.80, // control the size of the itmems
            ),
            itemCount: 10, // Replace with the number of items you need
            itemBuilder: (BuildContext context, int index) {
              return Container(
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
                        // ignore: unnecessary_null_comparison
                        child: Image(
                          image: AssetImage('assets/images/japan.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Japan',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Traditional Houses',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 2, // Limit to 2 lines
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Reviews (n)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 40,
            right: 40,
            child: reusableElevatedButton(
              text: 'Feature your place here!',
              onPressed: () {},
            ),
            )
        ],
      ),
    );
  }
}
