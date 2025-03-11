import 'package:coin_telelemedicina_web/controller/HomeController.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/screens/doctor_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/interpreter_screen.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: controller.sideMenu,
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryColor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.primaryColor,
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300)
                  )
                ),
                unselectedIconColor: Colors.black54,
                unselectedTitleTextStyle: const TextStyle(color: Colors.black54),
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
              ),
              title: Container(
                height: 200,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img.png'),
                  ),
                ),
              ),
              items: [
                SideMenuItem(
                  title: 'Doctor',
                  onTap: (index, _) => controller.changePage(index),
                  icon: const Icon(Icons.medical_services_outlined),
                ),
                SideMenuItem(
                  title: 'Interpreter',
                  onTap: (index, _) => controller.changePage(index),
                  icon: const Icon(Icons.translate_outlined),
                ),
                SideMenuItem(
                  title: 'Hospital',
                  onTap: (index, _) => controller.changePage(index),
                  icon: const Icon(Icons.local_hospital_outlined),
                ),
                SideMenuItem(
                  title: 'Services',
                  onTap: (index, _) => controller.changePage(index),
                  icon: const Icon(Icons.medical_information_outlined),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const DoctorScreen(),
                  const InterpreterScreen(),
                  const Center(child: Text('Hospital Screen')),
                  const Center(child: Text('Services Screen')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
