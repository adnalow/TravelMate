import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController email = TextEditingController();

  reset() async {
    if (email.text.isEmpty) {
      Get.snackbar("Input Error", "Please enter your email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white);
      return;
    }

    // Basic email format validation
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email.text)) {
      Get.snackbar("Input Error", "Please enter a valid email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white);
      return;
    }

    try {
      // Optionally show a loading indicator here
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Get.snackbar("Success", "Password reset email sent!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
      email.clear(); // Clear the email field after sending
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            ElevatedButton(
              onPressed: reset,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
