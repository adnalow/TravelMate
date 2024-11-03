import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText; // Parameter for label text
  final TextInputType? keyboardType; // Optional parameter for keyboard type

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText, // Make labelText required
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 250, // Set your fixed height here
      child: TextField(
        controller: controller,
        keyboardType: keyboardType, // Use the keyboardType parameter
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
          ), // Set the labelText from parameter
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF57CC99),
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF57CC99)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Color when enabled but not focused
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        ),
      ),
    );
  }
}
