import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_mate/Screens/forgot_password.dart';
import 'package:travel_mate/Screens/signup.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      resizeToAvoidBottomInset: false, // Prevents resizing when the keyboard appears
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
                      'Sign in now',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Please sign in to continue our app',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF808080),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter email',
                      width: double.infinity,
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Enter password',
                      width: double.infinity,
                      obscureText: true, // Hide the password input
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 300,
                      height: 45,
                      child: loginElevatedButton(
                        onPressed: isLoading ? null : signIn,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Mulish',
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF48B89F),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(SignupPage());
                              }
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(ForgotPage());
                      },
                      child: const Text(
                        'Forgot Password?',
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
        ],
      ),
    );
  }
}