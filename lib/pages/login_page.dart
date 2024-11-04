import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_mate/pages/forgot_page.dart';
import 'package:travel_mate/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Input Error", "Please fill in all fields.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white));
      return;
    }

    // Basic email format validation
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(emailController.text)) {
      Get.snackbar("Input Error", "Please enter a valid email address.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white));
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
          "Input Error", "Password must be at least 6 characters long.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "An error occurred.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
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
              obscureText: true, // Hide the password input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : signIn,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Login'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.to(SignupPage()),
              child: Text('Register'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.to(ForgotPage()),
              child: Text('Forgot password'),
            ),
          ],
        ),
      ),
    );
  }
}
