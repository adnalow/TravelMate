import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';

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
    return PopScope(
      canPop: true,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Enter your email to receive a password reset link',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: email,
                        labelText: 'Email',
                        hintText: 'Enter email',
                        width: double.infinity,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 300,
                        height: 45,
                        child: reusableElevatedButton(
                          onPressed: reset,
                          text: 'Reset Password',
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF48B89F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}