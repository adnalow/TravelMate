import 'package:get/get.dart';

class TabtabController extends GetxController {
  // Use Rx<int> to make the selected index reactive
  var selectedIndex = 2.obs; // Default to the "Home" tab (index 2)

  // Function to update the selected index
  void selectIndex(int index) {
    selectedIndex.value = index;
  }
}
