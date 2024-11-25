import 'package:flutter/material.dart';

ElevatedButton reusableElevatedButton({
  required String text,
  required VoidCallback? onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF57CC99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

ElevatedButton loginElevatedButton({
  String? text, // Optional text
  Widget? child, // Optional child widget
  required VoidCallback? onPressed, // Make onPressed nullable
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF57CC99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    onPressed: onPressed, // This can now accept null
    child: child ?? // Use the child if provided, otherwise fallback to text
        Text(
          text ?? '',
          
        ),
  );
}


ElevatedButton customElevatedButton({
  required String text,
  required VoidCallback onPressed,
  required Color backgroundColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}