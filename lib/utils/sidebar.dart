// import 'package:coin_telelemedicina_web/view/auth/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import '../controller/HomeController.dart';
//
// class SidebarMenu extends StatelessWidget {
//   final bool isFromMain; // Add this parameter
//
//   SidebarMenu({Key? key, this.isFromMain = false}) : super(key: key);
//   final HomeController controller = Get.find<HomeController>();
//
//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF1C8B4A);
//
//     return SizedBox(
//       width: 250,
//       child: SideMenu(
//         controller: controller.sideMenu,
//         style: SideMenuStyle(
//           displayMode: SideMenuDisplayMode.auto,
//           backgroundColor: Colors.white,
//           selectedColor: primaryColor,
//           selectedIconColor: Colors.white,
//           unselectedIconColor: Colors.black,
//           unselectedIconColorExpandable: Colors.black,
//           unselectedTitleTextStyleExpandable: TextStyle(
//               color: Colors.black
//           ),
//           selectedTitleTextStyleExpandable: TextStyle(
//               color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16
//           ),
//           unselectedTitleTextStyle: const TextStyle(color: Colors.black),
//           selectedTitleTextStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: primaryColor,
//             border: Border(right: BorderSide(color: Colors.grey.shade300)),
//           ),
//           arrowCollapse: Colors.black,
//           arrowOpen: Colors.black,
//           selectedIconColorExpandable: Colors.black,
//         ),
//         title: Container(
//           height: 150,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/img.png'), // Replace with your logo
//             ),
//           ),
//         ),
//         items: [
//           SideMenuItem(
//             title: 'dashboard'.tr, // Use translation key
//             icon: const Icon(Icons.dashboard),
//             onTap: (index, _) => controller.changePage(0 , isFromMain),
//           ),
//           SideMenuItem(
//             title: 'notifications'.tr, // Use translation key
//             icon: const Icon(Icons.notifications,color: Colors.black,),
//             onTap: (index, _) => controller.changePage(1, isFromMain),
//           ),
//           SideMenuExpansionItem(
//             title: 'users'.tr, // Use translation key
//             icon: const Icon(Icons.people,color: Colors.black),
//             children: [
//               SideMenuItem(
//                 title: 'patients'.tr, // Use translation key
//                 icon: const Icon(Icons.person,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(2, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'doctors'.tr, // Use translation key
//                 icon: const Icon(Icons.local_hospital_outlined,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(3, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'interpreters'.tr, // Use translation key
//                 icon: const Icon(Icons.translate_outlined,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(4, isFromMain),
//               ),
//             ],
//           ),
//           SideMenuExpansionItem(
//             title: 'content'.tr, // Use translation key
//             icon: const Icon(Icons.folder),
//             children: [
//               SideMenuItem(
//                 title: 'banners'.tr, // Use translation key
//                 icon: const Icon(Icons.image,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(5, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'services'.tr, // Use translation key
//                 icon: const Icon(Icons.medical_services,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(6, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'disabilities'.tr, // Use translation key
//                 icon: const Icon(Icons.accessible,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(7, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'health_centers'.tr, // Use translation key
//                 icon: const Icon(Icons.local_hospital,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(8, isFromMain),
//               ),
//               SideMenuItem(
//                 title: 'provinces'.tr, // Use translation key
//                 icon: const Icon(Icons.map,color: Colors.black),
//                 onTap: (index, _) => controller.changePage(9, isFromMain),
//               ),
//             ],
//           ),
//           SideMenuItem(
//             title: 'logout'.tr, // Use translation key
//             badgeColor: Colors.red,
//             iconWidget: Icon(Icons.logout_outlined, color: Colors.red),
//             onTap: (index, sideMenuController) async {
//               _showLogoutDialog(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     Get.dialog(
//       AlertDialog(
//         title: Text('confirm_logout'.tr), // Use translation key
//         content: Text('logout_message'.tr), // Use translation key
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text('cancel'.tr), // Use translation key
//           ),
//           TextButton(
//             onPressed: () async {
//               Get.back();
//               await FirebaseAuth.instance.signOut();
//               Get.offAll(() => const LoginScreen());
//             },
//             child: Text('logout'.tr), // Use translation key
//           ),
//         ],
//       ),
//     );
//   }
// }
///new code
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/HomeController.dart';
import '../view/auth/login_screen.dart';

class SidebarMenu extends StatefulWidget {
  final bool isFromMain;

  SidebarMenu({Key? key, this.isFromMain = false}) : super(key: key);

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  final HomeController controller = Get.find<HomeController>();
  int selectedIndex = 0;
  bool isUsersExpanded = false;
  bool isContentExpanded = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C8B4A);
    const Color unselectedColor = Colors.black54;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Center(
              child: Image.asset('assets/img.png', height: 80), // Logo
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'dashboard'.tr,
                  index: 0,
                ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'notifications'.tr,
                  index: 1,
                ),
                _buildMenuItem(
                  icon: Icons.my_library_books_outlined,
                  title: "Appointments",
                  index: 2,
                ),
                _buildExpandableMenu(
                  icon: Icons.people,
                  title: 'users'.tr,
                  isExpanded: isUsersExpanded,
                  onExpand: () => setState(() => isUsersExpanded = !isUsersExpanded),
                  children: [
                    _buildMenuItem(icon: Icons.person, title: 'patients'.tr, index: 3, isChild: true),
                    _buildMenuItem(icon: Icons.local_hospital_outlined, title: 'doctors'.tr, index: 4, isChild: true),
                    _buildMenuItem(icon: Icons.translate_outlined, title: 'interpreters'.tr, index: 5, isChild: true),
                  ],
                ),
                _buildExpandableMenu(
                  icon: Icons.folder,
                  title: 'content'.tr,
                  isExpanded: isContentExpanded,
                  onExpand: () => setState(() => isContentExpanded = !isContentExpanded),
                  children: [
                    _buildMenuItem(icon: Icons.image, title: 'banners'.tr, index: 6, isChild: true),
                    _buildMenuItem(icon: Icons.medical_services, title: 'services'.tr, index: 7, isChild: true),
                    _buildMenuItem(icon: Icons.accessible, title: 'disabilities'.tr, index: 8, isChild: true),
                    _buildMenuItem(icon: Icons.local_hospital, title: 'health_centers'.tr, index: 9, isChild: true),
                    _buildMenuItem(icon: Icons.map, title: 'provinces'.tr, index: 10, isChild: true),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: Colors.red),
                  title: Text('logout'.tr, style: TextStyle(color: Colors.red)),
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required int index, bool isChild = false}) {
    const Color primaryColor = Color(0xFF1C8B4A);
    const Color unselectedColor = Colors.black;

    return ListTile(
      leading: Icon(icon, color: selectedIndex == index ? Colors.white : unselectedColor),
      title: Text(
        title,
        style: TextStyle(color: selectedIndex == index ? Colors.white : unselectedColor),
      ),
      tileColor: selectedIndex == index ? primaryColor : Colors.transparent,
      contentPadding: EdgeInsets.only(left: isChild ? 40.0 : 16.0),
      onTap: () {
        setState(() => selectedIndex = index);
        controller.changePage(index, widget.isFromMain);
      },
    );
  }

  Widget _buildExpandableMenu({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onExpand,
    required List<Widget> children,
  }) {
    const Color unselectedColor = Colors.black;
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: unselectedColor),
          title: Text(title, style: TextStyle(color: unselectedColor)),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: unselectedColor),
          onTap: onExpand,
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_logout'.tr),
        content: Text('are_you_sure_logout'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              Get.back();
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}