import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText; // Optional parameter for label text
  final String hintText; // Parameter for hint text
  final TextInputType? keyboardType; // Optional parameter for keyboard type
  final double? width; // Parameter for adjustable width

  const CustomTextField({
    Key? key,
    required this.controller,
    this.labelText, // Make labelText optional
    required this.hintText, // Make hintText required
    this.keyboardType,
    this.width, // Add width parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show label text if provided
        if (labelText != null)
          Text(
            labelText!, // Display the label above the input field
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(
          height: 45,
          width: width ?? 250, // Use the adjustable width, default to 250 if null
          child: TextField(
            controller: controller,
            keyboardType: keyboardType, // Use the keyboardType parameter
            decoration: InputDecoration(
              hintText: hintText, // Use the hintText parameter
              hintStyle: const TextStyle(color: Colors.grey), // Set hint text color to grey
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
        ),
      ],
    );
  }
}
