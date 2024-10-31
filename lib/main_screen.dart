import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travel_mate/Screens/collab.dart';
import 'package:travel_mate/Screens/expense.dart';
import 'package:travel_mate/Screens/explore.dart';
import 'package:travel_mate/Screens/home.dart';
import 'package:travel_mate/Screens/plan.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 2;
  final screen = [
    ItineraryScreen(),
    CollaborativeScreen(),
    HomeScreen(),
    ExpenseTrackerScreen(),
    DiscoverScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        height: 60,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.calendar_edit),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.people),
            label: 'Collab',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.empty_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.global_search),
            label: 'Discover',
          ),
        ],
      ),
    );
  }
}
