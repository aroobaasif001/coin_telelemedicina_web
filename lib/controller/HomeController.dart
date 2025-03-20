import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageController = PageController();
  final sideMenu = SideMenuController();

  // Tracks the current page index
  final currentPage = 0.obs;

  // Tracks whether "Usuarios" sub-menu is expanded
  final usuariosExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for SideMenu taps:
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

  // Directly change page from code
  void changePage(int index) {
    currentPage.value = index;
    sideMenu.changePage(index);
  }

  // Toggle "Usuarios" submenu
  void toggleUsuarios() {
    usuariosExpanded.value = !usuariosExpanded.value;
  }
}



///


// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class HomeController extends GetxController {
//   final pageController = PageController();
//   final sideMenu = SideMenuController();
//   final currentPage = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Whenever the user taps a SideMenuItem, sideMenu will notify us of the index.
//     sideMenu.addListener((index) {
//       currentPage.value = index;
//       pageController.jumpToPage(index);
//     });
//   }
//
//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
//
//   void changePage(int index) {
//     currentPage.value = index;
//     sideMenu.changePage(index);
//   }
// }
