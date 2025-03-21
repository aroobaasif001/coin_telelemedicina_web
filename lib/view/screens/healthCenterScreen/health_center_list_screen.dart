// import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:coin_telelemedicina_web/model/health_center_model.dart';
// import 'health_ceenter_detail_screen.dart';
// import 'health_edit_screen.dart';

// class HealthCenterListScreen extends StatefulWidget {
//   @override
//   _HealthCenterListScreenState createState() => _HealthCenterListScreenState();
// }

// class _HealthCenterListScreenState extends State<HealthCenterListScreen> {
//   Stream<List<HealthCenterModel>> fetchHealthCenters() {
//     return FirebaseFirestore.instance.collection('healthCenters').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return HealthCenterModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         centerTitle: true,
//         title: Text('Health Centers',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),

//       body: StreamBuilder<List<HealthCenterModel>>(
//         stream: fetchHealthCenters(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No health centers found.'));
//           }

//           List<HealthCenterModel> centers = snapshot.data!;

//           return ListView.builder(
//             itemCount: centers.length,
//             itemBuilder: (context, index) {
//               final center = centers[index];
//               return Card(
//                 margin: EdgeInsets.all(8.0),
//                 child: ListTile(
//                   title: Text(center.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('📍 Address: ${center.address}'),
//                       Text('🌆 City: ${center.city}'),
//                       Text('✅ Status: ${center.isActive ? "Active" : "Inactive"}'),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == 'view') {
//                         Get.to(() => HealthCenterDetailScreen(center: center));
//                       } else if (value == 'edit') {
//                         Get.to(() => HealthCenterEditScreen(center: center));
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: 'view', child: Text('View Details')),
//                       PopupMenuItem(value: 'edit', child: Text('Edit')),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

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
        children: [
          CustomAppbar(title: 'Health Centers',),
          Expanded(
            child: CustomContainer(
              conColor: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Obx(() {
                if (healthCenterController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
            
                if (healthCenterController.healthCenters.isEmpty) {
                  return Center(child: Text('No health centers found.'));
                }
            
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: healthCenterController.healthCenters.length,
                  itemBuilder: (context, index) {
                    final center = healthCenterController.healthCenters[index];
                
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(center.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📍 Address: ${center.address}'),
                            Text('🌆 City: ${center.city}'),
                            Text('✅ Status: ${center.isActive ? "Active" : "Inactive"}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Get.to(() => HealthCenterDetailScreen(center: center));
                            } else if (value == 'edit') {
                              Get.to(() => HealthCenterEditScreen(center: center));
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'view', child: Text('View Details')),
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
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
          Get.to(() => HealthCenterScreen());
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
