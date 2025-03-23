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
          title: 'Health Centers',
        ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: TextField(
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search by name, email or disability...',
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
                return const Center(child: Text('No health centers found.'));
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
                      4: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Center Name",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Text("Address", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("City", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Text("Status", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Text("Actions", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                            3: FlexColumnWidth(2),
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
                                    center.isActive ? "Active" : "Inactive",
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
                                        icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 16),
                                        onPressed: () {

                                             Get.to(() => MainLayout(child:HealthCenterDetailScreen(center: center)));

                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.red, size: 16),
                                        onPressed: () {
                                             Get.to(() => MainLayout(child:HealthCenterEditScreen(center: center)));

                                          
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
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
           Get.to(() => MainLayout(child:HealthCenterScreen()));

        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
