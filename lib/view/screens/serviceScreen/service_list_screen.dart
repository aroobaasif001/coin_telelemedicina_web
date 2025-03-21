import 'package:coin_telelemedicina_web/view/screens/serviceScreen/service_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/AppTheme.dart';
import 'controller/service_controller.dart';
import 'service_detail_screen.dart';
import 'service_edit_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'Services List',),
          Expanded(
            child: CustomContainer(
              conColor: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Obx(() {
                if (serviceController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (serviceController.services.isEmpty) {
                  return Center(child: Text('No services found.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: serviceController.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceController.services[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: service.icon.isNotEmpty
                              ? NetworkImage(service.icon)
                              : AssetImage('assets/default_service.png') as ImageProvider,
                        ),
                        title: Text(service.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Price: \$${service.price} | Duration: ${service.duration} mins'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Get.to(() => ServiceDetailScreen(service: service));
                            } else if (value == 'edit') {
                              Get.to(() => ServiceEditScreen(service: service));
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'view', child: Text('View Details')),
                            PopupMenuItem(value: 'edit', child: Text('Edit Service')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ServiceScreen());
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      
    );
  }
}
