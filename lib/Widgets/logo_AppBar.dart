import 'package:flutter/material.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {

  const LogoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Make background transparent
      toolbarHeight: 50, // Set the height of the app bar
      automaticallyImplyLeading: false, 
      title: const Text(
        'TravelMate',
        style: TextStyle(
          color: Color(0xFF57CC99),
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true, // Center the title
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50); // Return the preferred height
}
