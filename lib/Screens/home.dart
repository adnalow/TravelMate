import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/Widgets/logo_AppBar.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onSelectIndex;

  const HomeScreen({super.key, required this.onSelectIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const LogoAppBar(),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Ready to find your\nnext destination?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF2E2E2E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Image(
                          image: AssetImage('assets/images/illustration1.png'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
