import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Title to be displayed in the app bar

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF57CC99), // Make background transparent
      toolbarHeight: 50,
      automaticallyImplyLeading: false,  // Set the height of the app bar
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true, // Center the title
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50); // Return the preferred height
}
