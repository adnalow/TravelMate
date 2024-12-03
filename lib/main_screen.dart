import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart'; 
import 'package:travel_mate/Screens/collab.dart';
import 'package:travel_mate/Screens/expense.dart';
import 'package:travel_mate/Screens/explore.dart';
import 'package:travel_mate/Screens/home.dart';
import 'package:travel_mate/Screens/itinerary.dart';
import 'package:travel_mate/Screens/displayChoice.dart';
import 'package:travel_mate/Widgets/onBack.dart';
import 'package:travel_mate/controllers/tab_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the TabController using GetX's reactive state management
    final TabtabController tabController = Get.put(TabtabController());

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final bool canPop = tabController.goBack();
        if (!canPop) {
          // If we're at the home tab (index 2), show the exit confirmation
          if (tabController.selectedIndex.value == 2) {
            return await onBackPressed(context);
          }
          // If we're not at the home tab, go to the home tab
          tabController.selectIndex(2);
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: Obx(() {
          // This will rebuild the selected screen based on the selected index
          switch (tabController.selectedIndex.value) {
            case 0:
              return _buildNavigator(ItineraryScreen(), 'Itinerary');
            case 1:
              return CollaborativeScreen();
            case 2:
              return HomeScreen(onSelectIndex: tabController.selectIndex);
            case 3:
              return ExpenseTrackerScreen();
            case 4:
              return DiscoverScreen();
            default:
              return HomeScreen(onSelectIndex: tabController.selectIndex);
          }
        }),
        bottomNavigationBar: Obx(() {
          // Reactive NavigationBar: it listens to selectedIndex and updates accordingly
          return NavigationBar(
            selectedIndex: tabController.selectedIndex.value, // Highlight selected index
            indicatorColor: Colors.black.withOpacity(0.1),
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            height: 60,
            onDestinationSelected: tabController.selectIndex, // Update the index when a tab is tapped
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.calendar_edit), label: 'Build'),
              NavigationDestination(icon: Icon(Iconsax.people), label: 'Collab'),
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.empty_wallet), label: 'Budget'),
              NavigationDestination(icon: Icon(Iconsax.global_search), label: 'Discover'),
            ],
          );
        }),
      ),
    );
  }

  // Updated method for navigation with GetX
  Widget _buildNavigator(Widget screen, String initialRoute) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        Widget page = screen;
        if (settings.name == 'DisplayChoice') {
          page = DisplayChoice(
            promptFormat: settings.arguments as String,
            onSelectIndex: (index) {
              // Use GetX to update the selected index
              Get.find<TabtabController>().selectIndex(index);
            },
            selectedCategory: ' ',
          );
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}
