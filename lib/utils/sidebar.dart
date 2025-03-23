import 'package:coin_telelemedicina_web/view/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../controller/HomeController.dart';

class SidebarMenu extends StatelessWidget {
  final bool isFromMain; // Add this parameter

  SidebarMenu({Key? key, this.isFromMain = false}) : super(key: key);
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C8B4A);

    return SizedBox(
      width: 250,
      child: SideMenu(
        controller: controller.sideMenu,
        style: SideMenuStyle(
          displayMode: SideMenuDisplayMode.auto,
          backgroundColor: Colors.white,
          selectedColor: primaryColor,
          selectedIconColor: Colors.white,
          unselectedIconColor: Colors.black,
          unselectedIconColorExpandable: Colors.black,
          unselectedTitleTextStyleExpandable: TextStyle(
              color: Colors.black
          ),
          selectedTitleTextStyleExpandable: TextStyle(
              color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16
          ),
          unselectedTitleTextStyle: const TextStyle(color: Colors.black),
          selectedTitleTextStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: primaryColor,
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          arrowCollapse: Colors.black,
          arrowOpen: Colors.black,
          selectedIconColorExpandable: Colors.black,
        ),
        title: Container(
          height: 150,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img.png'), // Replace with your logo
            ),
          ),
        ),
        items: [
          SideMenuItem(
            title: 'dashboard'.tr, // Use translation key
            icon: const Icon(Icons.dashboard),
            onTap: (index, _) => controller.changePage(0 , isFromMain),
          ),
          SideMenuItem(
            title: 'notifications'.tr, // Use translation key
            icon: const Icon(Icons.notifications,color: Colors.black,),
            onTap: (index, _) => controller.changePage(1, isFromMain),
          ),
          SideMenuExpansionItem(
            title: 'users'.tr, // Use translation key
            icon: const Icon(Icons.people,color: Colors.black),
            children: [
              SideMenuItem(
                title: 'patients'.tr, // Use translation key
                icon: const Icon(Icons.person,color: Colors.black),
                onTap: (index, _) => controller.changePage(2, isFromMain),
              ),
              SideMenuItem(
                title: 'doctors'.tr, // Use translation key
                icon: const Icon(Icons.local_hospital_outlined,color: Colors.black),
                onTap: (index, _) => controller.changePage(3, isFromMain),
              ),
              SideMenuItem(
                title: 'interpreters'.tr, // Use translation key
                icon: const Icon(Icons.translate_outlined,color: Colors.black),
                onTap: (index, _) => controller.changePage(4, isFromMain),
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: 'content'.tr, // Use translation key
            icon: const Icon(Icons.folder),
            children: [
              SideMenuItem(
                title: 'banners'.tr, // Use translation key
                icon: const Icon(Icons.image,color: Colors.black),
                onTap: (index, _) => controller.changePage(5, isFromMain),
              ),
              SideMenuItem(
                title: 'services'.tr, // Use translation key
                icon: const Icon(Icons.medical_services,color: Colors.black),
                onTap: (index, _) => controller.changePage(6, isFromMain),
              ),
              SideMenuItem(
                title: 'disabilities'.tr, // Use translation key
                icon: const Icon(Icons.accessible,color: Colors.black),
                onTap: (index, _) => controller.changePage(7, isFromMain),
              ),
              SideMenuItem(
                title: 'health_centers'.tr, // Use translation key
                icon: const Icon(Icons.local_hospital,color: Colors.black),
                onTap: (index, _) => controller.changePage(8, isFromMain),
              ),
              SideMenuItem(
                title: 'provinces'.tr, // Use translation key
                icon: const Icon(Icons.map,color: Colors.black),
                onTap: (index, _) => controller.changePage(9, isFromMain),
              ),
            ],
          ),
          SideMenuItem(
            title: 'logout'.tr, // Use translation key
            badgeColor: Colors.red,
            iconWidget: Icon(Icons.logout_outlined, color: Colors.red),
            onTap: (index, sideMenuController) async {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_logout'.tr), // Use translation key
        content: Text('logout_message'.tr), // Use translation key
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancel'.tr), // Use translation key
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
            child: Text('logout'.tr), // Use translation key
          ),
        ],
      ),
    );
  }
}