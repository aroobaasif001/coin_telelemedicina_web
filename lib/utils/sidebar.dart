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
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
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
                  title: 'Dashboard',
                  index: 0,
                ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  index: 1,
                ),
                _buildExpandableMenu(
                  icon: Icons.people,
                  title: 'Users',
                  isExpanded: isUsersExpanded,
                  onExpand: () => setState(() => isUsersExpanded = !isUsersExpanded),
                  children: [
                    _buildMenuItem(icon: Icons.person, title: 'Patients', index: 2, isChild: true),
                    _buildMenuItem(icon: Icons.local_hospital_outlined, title: 'Doctors', index: 3, isChild: true),
                    _buildMenuItem(icon: Icons.translate_outlined, title: 'Interpreters', index: 4, isChild: true),
                  ],
                ),
                _buildExpandableMenu(
                  icon: Icons.folder,
                  title: 'Content',
                  isExpanded: isContentExpanded,
                  onExpand: () => setState(() => isContentExpanded = !isContentExpanded),
                  children: [
                    _buildMenuItem(icon: Icons.image, title: 'Banners', index: 5, isChild: true),
                    _buildMenuItem(icon: Icons.medical_services, title: 'Services', index: 6, isChild: true),
                    _buildMenuItem(icon: Icons.accessible, title: 'Disabilities', index: 7, isChild: true),
                    _buildMenuItem(icon: Icons.local_hospital, title: 'Health Centers', index: 8, isChild: true),
                    _buildMenuItem(icon: Icons.map, title: 'Provinces', index: 9, isChild: true),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
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
    const Color unselectedColor = Colors.black54;

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
    const Color unselectedColor = Colors.black54;
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
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
