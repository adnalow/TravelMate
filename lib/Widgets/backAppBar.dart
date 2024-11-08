import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color titleColor;

  const BackAppBar({
    Key? key,
    this.onBackPressed,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.white,
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: const Color(0xFF000000).withOpacity(0.25), // Dark blue color for back button
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: iconColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
