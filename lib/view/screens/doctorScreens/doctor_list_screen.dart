import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/AppTheme.dart';
import 'controller/doctor_controller.dart';
import 'doctor_detail_screen.dart';
import 'doctor_edit_screen.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';

class DoctorListScreen extends StatelessWidget {
  final DoctorController doctorController = Get.put(DoctorController());

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'doctors_list'.tr),
          Expanded(
            child: CustomContainer(
              margin: EdgeInsets.all(isSmallScreen ? 5 : 10),
              padding: EdgeInsets.all(isSmallScreen ? 5 : 10),
              borderRadius: BorderRadius.circular(10),
              conColor: Colors.white,
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                      decoration: InputDecoration(
                        hintText: 'search_hint'.tr,
                        prefixIcon: Icon(Icons.search, size: isSmallScreen ? 16 : 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 16),

                  // Doctor List
                  Expanded(
                    child: Obx(() {
                      if (doctorController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (doctorController.doctors.isEmpty) {
                        return Center(child: Text('no_doctors_found'.tr));
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: isSmallScreen
                                ? MediaQuery.of(context).size.width - 20
                                : 800,
                          ),
                          child: DataTable(
                            columnSpacing: isSmallScreen ? 8 : 16,
                            horizontalMargin: isSmallScreen ? 8 : 16,
                            columns: [
                              DataColumn(
                                label: Text('doctor'.tr,
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 13,
                                        fontWeight: FontWeight.bold
                                    )),
                              ),
                              DataColumn(
                                label: Text('specialty'.tr,
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 13,
                                        fontWeight: FontWeight.bold
                                    )),
                              ),
                              if (!isSmallScreen) DataColumn(
                                label: Text('experience'.tr,
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 13,
                                        fontWeight: FontWeight.bold
                                    )),
                              ),
                              if (!isSmallScreen) DataColumn(
                                label: Text('rating'.tr,
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 13,
                                        fontWeight: FontWeight.bold
                                    )),
                              ),
                              DataColumn(
                                label: Text('actions'.tr,
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 13,
                                        fontWeight: FontWeight.bold
                                    )),
                              ),
                            ],
                            rows: doctorController.doctors.map((doctor) {
                              return DataRow(cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: isSmallScreen ? 20 : 30,
                                        backgroundColor: Colors.grey[300],
                                        child: ClipOval(
                                          child: Image.network(
                                            doctor.photoUrl,
                                            width: isSmallScreen ? 40 : 60,
                                            height: isSmallScreen ? 40 : 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print("Error loading doctor image: ${doctor.photoUrl}");
                                              return Image.asset(
                                                'assets/img.png',
                                                width: isSmallScreen ? 40 : 60,
                                                height: isSmallScreen ? 40 : 60,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 5 : 10),
                                      Flexible(
                                        child: Text(
                                          doctor.fullName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 12 : 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    doctor.specialty,
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!isSmallScreen) DataCell(
                                  Text(
                                    '${doctor.experience} ${'years'.tr}',
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                  ),
                                ),
                                if (!isSmallScreen) DataCell(
                                  Text(
                                    '${doctor.rating} ${'star'.tr}',
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.remove_red_eye,
                                            color: Colors.blue,
                                            size: isSmallScreen ? 16 : 20),
                                        onPressed: () {
                                          Get.to(() => MainLayout(child: DoctorDetailScreen(doctor: doctor)));
                                        },
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.edit,
                                            color: Colors.red,
                                            size: isSmallScreen ? 16 : 20),
                                        onPressed: () {
                                          Get.to(() => MainLayout(child: EditDoctorScreen(doctor: doctor)));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => MainLayout(child: DoctorScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


///

// import 'package:coin_telelemedicina_web/view/home_screen.dart';
// import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_screen.dart';
// import 'package:coin_telelemedicina_web/view/screens/patient/patient_view_screen.dart';
// import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
// import 'package:coin_telelemedicina_web/widget/custom_container.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../utils/AppTheme.dart';
// import 'controller/doctor_controller.dart';
// import 'doctor_detail_screen.dart';
// import 'doctor_edit_screen.dart';
//
// class DoctorListScreen extends StatelessWidget {
//   final DoctorController doctorController = Get.put(DoctorController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppbar(title: 'doctors_list'.tr), // Use translation key
//           // Doctor List
//           Expanded(
//             child: CustomContainer(
//               margin: const EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//               borderRadius: BorderRadius.circular(10),
//               conColor: Colors.white,
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
//                     ),
//                     child: TextField(
//                       style: const TextStyle(fontSize: 13),
//                       decoration: InputDecoration(
//                         hintText: 'search_hint'.tr, // Use translation key
//                         prefixIcon: Icon(Icons.search, size: 13),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.all(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: Obx(
//                           () {
//                         if (doctorController.isLoading.value) {
//                           return Center(child: CircularProgressIndicator());
//                         }
//
//                         if (doctorController.doctors.isEmpty) {
//                           return Center(child: Text('no_doctors_found'.tr)); // Use translation key
//                         }
//
//                         return Column(
//                           children: [
//                             Table(
//                               columnWidths: const {
//                                 0: FlexColumnWidth(3),
//                                 1: FlexColumnWidth(2),
//                                 2: FlexColumnWidth(2),
//                                 3: FlexColumnWidth(2),
//                                 4: FlexColumnWidth(1),
//                                 5: FlexColumnWidth(1),
//                               },
//                               children: [
//                                 TableRow(
//                                   decoration: BoxDecoration(
//                                     border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//                                   ),
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('doctor'.tr, // Use translation key
//                                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('specialty'.tr, // Use translation key
//                                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('experience'.tr, // Use translation key
//                                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('rating'.tr, // Use translation key
//                                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('actions'.tr, // Use translation key
//                                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                               child: ListView.builder(
//                                 itemCount: doctorController.doctors.length,
//                                 itemBuilder: (context, index) {
//                                   final doctor = doctorController.doctors[index];
//                                   return Table(
//                                     columnWidths: const {
//                                       0: FlexColumnWidth(3),
//                                       1: FlexColumnWidth(2),
//                                       2: FlexColumnWidth(2),
//                                       3: FlexColumnWidth(2),
//                                       4: FlexColumnWidth(1),
//                                       5: FlexColumnWidth(2),
//                                     },
//                                     children: [
//                                       TableRow(
//                                         decoration: BoxDecoration(
//                                           border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//                                         ),
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 CircleAvatar(
//                                                   radius: 30,
//                                                   backgroundColor: Colors.grey[300],
//                                                   child: ClipOval(
//                                                     child: Image.network(
//                                                       doctor.photoUrl,
//                                                       width: 60,
//                                                       height: 60,
//                                                       fit: BoxFit.cover,
//                                                       errorBuilder: (context, error, stackTrace) {
//                                                         print("Error loading doctor image: ${doctor.photoUrl}");
//                                                         return Image.asset('assets/img.png',
//                                                             width: 60, height: 60, fit: BoxFit.cover);
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Flexible(
//                                                   child: Text(
//                                                     doctor.fullName,
//                                                     style: TextStyle(fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(doctor.specialty),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text('${doctor.experience} ${'years'.tr}'), // Use translation key
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text('${doctor.rating} ${'star'.tr}'), // Use translation key
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 IconButton(
//                                                   icon: const Icon(Icons.remove_red_eye,
//                                                       color: Colors.blue, size: 20),
//                                                   onPressed: () {
//                                                     Get.to(() => MainLayout(child: DoctorDetailScreen(doctor: doctor)));
//                                                   },
//                                                 ),
//                                                 IconButton(
//                                                   icon: const Icon(Icons.edit, color: Colors.red, size: 20),
//                                                   onPressed: () {
//                                                     Get.to(() => MainLayout(child: EditDoctorScreen(doctor: doctor)));
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.to(() => MainLayout(child: DoctorScreen()));
//         },
//         backgroundColor: AppTheme.primaryColor,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }