import 'package:coin_telelemedicina_web/view/screens/banner/banner_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/dashboardScreen/dashboard_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/healthCenterScreen/health_center_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_list_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/notification/notification_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/patient/patient_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/serviceScreen/service_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../controller/HomeController.dart';
import 'screens/Provinces/provinceScreen/province_screen.dart';
import 'screens/disabalityScreens/disablity_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C8B4A); // Primary color

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // ============== SIDE MENU ==============
            SideMenu(
              controller: controller.sideMenu,
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                backgroundColor: Colors.white,
                selectedColor: primaryColor,
                selectedIconColor: Colors.white,
                unselectedIconColor: Colors.black54,
                unselectedTitleTextStyle: const TextStyle(color: Colors.black54),
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryColor,
                  border: Border(right: BorderSide(color: Colors.grey.shade300)),
                ),
                arrowCollapse: Colors.grey,
                arrowOpen: Colors.grey,
                selectedIconColorExpandable: Colors.grey,
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
                // Dashboard
                SideMenuItem(
                  title: 'Dashboard',
                  icon: const Icon(Icons.dashboard),
                  onTap: (index, _) => controller.changePage(0),
                ),

                // Notifications
                SideMenuItem(
                  title: 'Notifications',
                  icon: const Icon(Icons.notifications),
                  onTap: (index, _) => controller.changePage(1),
                ),

                // Users (Collapsible)
                SideMenuExpansionItem(
                  title: 'Users',
                  icon: const Icon(Icons.people),
                  children: [
                    SideMenuItem(
                      title: 'Patients',
                      icon: const Icon(Icons.person),
                      onTap: (index, _) => controller.changePage(2),
                    ),
                    SideMenuItem(
                      title: 'Doctors',
                      icon: const Icon(Icons.local_hospital_outlined),
                      onTap: (index, _) => controller.changePage(3),
                    ),
                    SideMenuItem(
                      title: 'Interpreters',
                      icon: const Icon(Icons.translate_outlined),
                      onTap: (index, _) => controller.changePage(4),
                    ),
                  ],
                ),

                // Content (Collapsible)
                SideMenuExpansionItem(
                  title: 'Content',
                  icon: const Icon(Icons.folder),
                  children: [
                    SideMenuItem(
                      title: 'Banners',
                      icon: const Icon(Icons.image),
                      onTap: (index, _) => controller.changePage(5),
                    ),
                    SideMenuItem(
                      title: 'Services',
                      icon: const Icon(Icons.medical_services),
                      onTap: (index, _) => controller.changePage(6),
                    ),
                    SideMenuItem(
                      title: 'Disabilities',
                      icon: const Icon(Icons.accessible),
                      onTap: (index, _) => controller.changePage(7),
                    ),
                    SideMenuItem(
                      title: 'Health Centers',
                      icon: const Icon(Icons.local_hospital),
                      onTap: (index, _) => controller.changePage(8),
                    ),
                    SideMenuItem(
                      title: 'Provinces',
                      icon: const Icon(Icons.map),
                      onTap: (index, _) => controller.changePage(9),
                    ),
                  ],
                ),

                // Management (Collapsible)
                SideMenuExpansionItem(
                  title: 'Management',
                  icon: const Icon(Icons.calendar_today),
                  children: [
                    SideMenuItem(
                      title: 'Chats',
                      icon: const Icon(Icons.chat),
                      onTap: (index, _) => controller.changePage(10),
                    ),
                    SideMenuItem(
                      title: 'Availability',
                      icon: const Icon(Icons.access_time),
                      onTap: (index, _) => controller.changePage(11),
                    ),
                    SideMenuItem(
                      title: 'Calls',
                      icon: const Icon(Icons.phone),
                      onTap: (index, _) => controller.changePage(12),
                    ),
                  ],
                ),

                // Admin Panel (Collapsible)
                SideMenuExpansionItem(
                  title: 'Admin Panel',
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  children: [
                    SideMenuItem(
                      title: 'Roles & Permissions',
                      icon: const Icon(Icons.security),
                      onTap: (index, _) => controller.changePage(13),
                    ),
                    SideMenuItem(
                      title: 'Admin Users',
                      icon: const Icon(Icons.supervisor_account),
                      onTap: (index, _) => controller.changePage(14),
                    ),
                  ],
                ),
              ],
            ),

            // ============== MAIN VIEW ==============
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DashboardScreen(),     // index 0
                  NotificationScreen(),  // index 1
                  Text("Patients"),      // index 2
               DoctorListScreen(),
                  InterpreterListScreen(),   // index 4
                BannersScreen(),      // index 5
                 ServiceListScreen(),      // index 6
                 DisabilityScreen(),
                  HealthCenterListScreen(), // index 8
               // AddProvinceScreen(),
                 ProvinceScreen(),   // index 9
                  Text("Chats"),         // index 10
                  Text("Availability"),  // index 11
                  Text("Calls"),         // index 12
                  Text("Roles & Permissions"), // index 13
                  Text("Admin Users"), // index 14
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

