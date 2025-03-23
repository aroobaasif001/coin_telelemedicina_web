import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/serviceScreen/service_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/service_controller.dart';
import 'service_detail_screen.dart';
import 'service_edit_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(title: 'service_management'.tr), // Use translation key
          // Add New Service Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() => MainLayout(child: ServiceScreen()));
              },
              icon: const Icon(Icons.add),
              label: Text('add_new_service'.tr), // Use translation key
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
          // Service List Grid
          Expanded(
            child: Obx(() {
              if (serviceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (serviceController.services.isEmpty) {
                return Center(child: Text('no_services_found'.tr)); // Use translation key
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: serviceController.services.length,
                itemBuilder: (context, index) {
                  final service = serviceController.services[index];

                  return CustomContainer(
                    conColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Icon and Name
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: service.icon.isNotEmpty
                                  ? NetworkImage(service.icon)
                                  : const AssetImage('assets/default_service.png') as ImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                service.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Service Description
                        Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Duration and Price
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text('${service.duration} ${'min'.tr}'), // Use translation key
                            const SizedBox(width: 12),
                            const Icon(Icons.attach_money, size: 16),
                            const SizedBox(width: 4),
                            Text('${service.price}'),
                          ],
                        ),
                        const Spacer(),
                        // Status and Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: service.isActive ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                service.isActive ? 'active'.tr : 'inactive'.tr, // Use translation key
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            // Edit & Delete Actions
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    Get.to(() => MainLayout(child: ServiceEditScreen(service: service)));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Uncomment to enable delete
                                    // serviceController.deleteService(service.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}