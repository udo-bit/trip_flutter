import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final currentIndex = 0.obs;
  final PageController controller = PageController(initialPage: 0);

  void onBottomNavTap(int index) {
    currentIndex.value = index;
    controller.jumpToPage(index);
  }
}
