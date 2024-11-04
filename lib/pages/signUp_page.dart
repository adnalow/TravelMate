import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_mate/wrapper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      Get.snackbar("Input Error", "Please enter your email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white);
      return;
    }

    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      Get.snackbar("Input Error", "Please enter a valid email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Input Error", "Password must be at least 6 characters long.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      Get.offAll(Wrapper());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Enter password'),
              obscureText: true, // Hide password input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : signup,
              child: isLoading ? CircularProgressIndicator() : Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
