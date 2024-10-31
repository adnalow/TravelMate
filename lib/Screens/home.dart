import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        toolbarHeight: 50, 
        title: const Text(
          'TravelMate',
          style: TextStyle(
            color: Color(0xFF57CC99),
            fontSize: 26, // Set the text color to the color from the image
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true, // Centers the title
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10, 
                vertical: 30,
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // horizontally centered
                children: [

                  // Title
                  const Text(
                    'Ready to find your\nnext destination?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color:  Color(0xFF2E2E2E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Image(
                    image: AssetImage('assets/images/illustration1.png'),
                    width: double.infinity,
                  ),
                  const SizedBox(height: 40),

                  SizedBox( 
                    width: 280,
                    height: 45,
                    child: reusableElevatedButton(
                      text: "Let's Go!", 
                      onPressed: () {
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(builder: (context) => const LoginScreen()),
                        //);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
      
    );
  }
}