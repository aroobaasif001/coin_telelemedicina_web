import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/healthCenterScreen/controller/health_center_controller.dart';
import 'package:coin_telelemedicina_web/view/screens/healthCenterScreen/health_center_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/AppTheme.dart';
import 'health_ceenter_detail_screen.dart';
import 'health_edit_screen.dart';

class HealthCenterListScreen extends StatelessWidget {
  final HealthCenterController healthCenterController = Get.put(HealthCenterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 10,
        children: [
          CustomAppbar(
            title: 'health_centers'.tr, // Use translation key
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
            ),
            child: TextField(
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr, // Use translation key
                prefixIcon: Icon(Icons.search, size: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomContainer(
              conColor: Colors.white,
              margin: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Obx(() {
                if (healthCenterController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (healthCenterController.healthCenters.isEmpty) {
                  return Center(child: Text('no_health_centers_found'.tr)); // Use translation key
                }

                return Column(
                  children: [
                    // Table Header
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade200),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('center_name'.tr, // Use translation key
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('address'.tr, // Use translation key
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('city'.tr, // Use translation key
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('status'.tr, // Use translation key
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('actions'.tr, // Use translation key
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Data Rows
                    Expanded(
                      child: ListView.builder(
                        itemCount: healthCenterController.healthCenters.length,
                        itemBuilder: (context, index) {
                          final center = healthCenterController.healthCenters[index];
                          return Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey)),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(center.name),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(center.address),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(center.city),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      center.isActive ? 'active'.tr : 'inactive'.tr, // Use translation key
                                      style: TextStyle(
                                        color: center.isActive ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 20),
                                          onPressed: () {
                                            Get.to(() => MainLayout(child: HealthCenterDetailScreen(center: center)));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.red, size: 20),
                                          onPressed: () {
                                            Get.to(() => MainLayout(child: HealthCenterEditScreen(center: center)));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => MainLayout(child: HealthCenterScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}