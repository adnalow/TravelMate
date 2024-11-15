import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSignOut;

  const LogoAppBar({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
      title: const Text(
        'TravelMate',
        style: TextStyle(
          color: Color(0xFF57CC99),
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: onSignOut, // Use the signout callback here
        icon: const Icon(Iconsax.logout),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
