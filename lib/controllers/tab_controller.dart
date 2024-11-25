import 'package:get/get.dart';

class TabtabController extends GetxController {
  var selectedIndex = 2.obs; // Default to the "Home" tab (index 2)
  var indexHistory = <int>[2].obs; // Start with home index in history

  void selectIndex(int index) {
    if (selectedIndex.value != index) {
      indexHistory.add(selectedIndex.value);
      selectedIndex.value = index;
    }
  }

  bool goBack() {
    if (indexHistory.isNotEmpty) {
      selectedIndex.value = indexHistory.last;
      indexHistory.removeLast();
      return true;
    }
    return false;
  }
}

