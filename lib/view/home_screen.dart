import 'package:coin_telelemedicina_web/utils/sidebar.dart';
import 'package:coin_telelemedicina_web/view/auth/login_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/banner/banner_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/dashboardScreen/dashboard_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/healthCenterScreen/health_center_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/notification/notification_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/patient/patient_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/serviceScreen/service_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../controller/HomeController.dart';
import 'screens/Provinces/provinceScreen/province_screen.dart';
import 'screens/disabalityScreens/disablity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/HomeController.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [

            SidebarMenu(isFromMain: false,), // Use extracted SidebarMenu widget
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.stackIndex,
                  children: [
                    DashboardScreen(),
                    NotificationScreen(),
                    PatientScreen(),
                    DoctorListScreen(),
                    InterpreterListScreen(),
                    BannersScreen(),
                    ServiceListScreen(),
                    DisabilityScreen(),
                    HealthCenterListScreen(),
                    ProvinceScreen(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget? child; // Allows dynamic content
  MainLayout({Key? key, this.child}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarMenu(isFromMain: true,), // Sidebar remains the same
            Expanded(
              child: child ??
                  Obx(
                    () => IndexedStack(
                      index: controller.stackIndex,
                      children: [
                        DashboardScreen(),
                        NotificationScreen(),
                        PatientScreen(),
                        DoctorListScreen(),
                        InterpreterListScreen(),
                        BannersScreen(),
                        ServiceListScreen(),
                        DisabilityScreen(),
                        HealthCenterListScreen(),
                        ProvinceScreen(),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
