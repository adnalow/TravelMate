import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/Widgets/logo_AppBar.dart';
import 'package:travel_mate/Widgets/onBack.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onSelectIndex;

  const HomeScreen({super.key, required this.onSelectIndex});

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: LogoAppBar(onSignOut: signout),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Text(
                    'Ready to find your\nnext destination?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF2E2E2E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
    
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image(
                        image: AssetImage('assets/images/illustration1.png'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
    
                Positioned(
                  bottom: 30,
                  left: 50,
                  right: 50, // Center the button horizontally
                  child: SizedBox(
                    width: 280,
                    height: 45,
                    child: reusableElevatedButton(
                      text: "Let's Go!",
                      onPressed: () {
                        onSelectIndex(0); // Set to 0 for ItineraryScreen
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
