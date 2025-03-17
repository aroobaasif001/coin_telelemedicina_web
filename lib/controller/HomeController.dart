import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageController = PageController();
  final sideMenu = SideMenuController();
  final currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    sideMenu.addListener((index) {
      currentPage.value = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    currentPage.value = index;
    sideMenu.changePage(index);
  }
  
}