import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:get/get.dart';
import 'package:coin_telelemedicina_web/view/screens/patient/patient_view_screen.dart';
import 'add_patient_screen.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key}) : super(key: key);

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(title: 'patient_management'.tr),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'patient_management'.tr,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: const Icon(Icons.add, color: Colors.white, size: 13),
                    label: Text('new_patient'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientRegistrationScreen(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            CustomContainer(
              margin: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              conColor: Colors.white,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'search_hint'.tr,
                        prefixIcon: Icon(Icons.search, size: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('patients')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var patients = snapshot.data!.docs;

                      var filteredPatients = patients.where((doc) {
                        var patient = doc.data() as Map<String, dynamic>;
                        return patient['fullName']
                                    ?.toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ==
                                true ||
                            patient['email']
                                    ?.toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ==
                                true ||
                            patient['disability']
                                    ?.toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ==
                                true;
                      }).toList();

                      return Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(5),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(2),
                                5: FlexColumnWidth(3),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('patient'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('disability'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('gender'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('status'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('registration'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('actions'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 1, color: Colors.grey),
                            const Divider(height: 1, color: Colors.grey),
                            SizedBox(
                              height: 500,
                              child: ListView.builder(
                                itemCount: filteredPatients.length,
                                itemBuilder: (context, index) {
                                  var patient = filteredPatients[index].data()
                                      as Map<String, dynamic>;
                                  var patientId = filteredPatients[index].id;

                                  return Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(4),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(2),
                                      5: FlexColumnWidth(3),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade300)),
                                        ),
                                        children: [
                                          // Patient Name & Email
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(patient['fullName'] ?? '',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(patient['email'] ?? '',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ],
                                            ),
                                          ),
                                          // Disability
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                  patient['disability'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                              backgroundColor:
                                                  AppTheme.lightGreen,
                                            ),
                                          ),
                                          // Gender
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                patient['gender']
                                                            ?.toLowerCase() ==
                                                        'male'
                                                    ? 'male'.tr
                                                    : 'female'.tr,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                                  (patient['gender']
                                                              ?.toLowerCase() ==
                                                          'male')
                                                      ? Colors.black
                                                      : Colors.blue,
                                            ),
                                          ),
                                          // Status
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                  patient['status'] ?? '',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                              backgroundColor:
                                                  AppTheme.lightGreen,
                                            ),
                                          ),
                                          // Registration Date
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.calendar_today,
                                                    size: 13),
                                                const SizedBox(width: 4),
                                                Text(
                                                  patient['regDate']
                                                          is Timestamp
                                                      ? (patient['regDate']
                                                              as Timestamp)
                                                          .toDate()
                                                          .toLocal()
                                                          .toString()
                                                          .split(' ')[0]
                                                      : patient['regDate'] ??
                                                          '',
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Actions
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // View Button
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.blue,
                                                      size: 22),
                                                  onPressed: () {
                                                    Get.to(() => MainLayout(
                                                        child:
                                                            PatientViewScreen(
                                                              patientId:patient['uid'] ,
                                                                patient:
                                                                    patient)));
                                                  },
                                                ),
                                                // Edit Button
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.green,
                                                      size: 22),
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        PatientRegistrationScreen(
                                                            patientData: patient,
                                                            patientId: patientId,
                                                            isEditMode: true,
                                                            ));
                                                  },
                                                ),
                                                // Delete Button
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red,
                                                      size: 22),
                                                  onPressed: () {
                                                    Get.defaultDialog(
                                                      title:
                                                          "Delete Patient".tr,
                                                      middleText:
                                                          "Are you sure you want to delete this patient?"
                                                              .tr,
                                                      textConfirm: "Yes".tr,
                                                      textCancel: "No".tr,
                                                      confirmTextColor:
                                                          Colors.white,
                                                      onConfirm: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'patients')
                                                            .doc(patientId)
                                                            .delete();
                                                        Get.back();
                                                      },
                                                    );
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
// import 'package:coin_telelemedicina_web/view/home_screen.dart';
// import 'package:coin_telelemedicina_web/widget/custom_container.dart';
// import 'package:flutter/material.dart';
// import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
// import 'package:coin_telelemedicina_web/widget/CustomText.dart';
// import 'package:get/get.dart';
// import 'package:coin_telelemedicina_web/view/screens/patient/patient_view_screen.dart';
// import 'add_patient_screen.dart';
//
// class PatientScreen extends StatefulWidget {
//   const PatientScreen({Key? key}) : super(key: key);
//
//   @override
//   _PatientScreenState createState() => _PatientScreenState();
// }
//
// class _PatientScreenState extends State<PatientScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SingleChildScrollView(
//         // Added ScrollView for overall body
//         child: Column(
//           children: [
//             CustomAppbar(title: 'patient_management'.tr), // Use translation key
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomText(
//                     text: 'patient_management'.tr, // Use translation key
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   ElevatedButton.icon(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     icon: const Icon(Icons.add, color: Colors.white, size: 13),
//                     label: Text('new_patient'.tr,
//                         style: TextStyle(color: Colors.white, fontSize: 13)),
//                     // Use translation key
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PatientRegistrationScreen(),
//                           ));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             CustomContainer(
//               margin: const EdgeInsets.all(10),
//               borderRadius: BorderRadius.circular(10),
//               conColor: Colors.white,
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _searchController,
//                       style: const TextStyle(fontSize: 13),
//                       decoration: InputDecoration(
//                         hintText: 'search_hint'.tr, // Use translation key
//                         prefixIcon: Icon(Icons.search, size: 13),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.all(12),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value; // Update search query
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('patients')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       var patients = snapshot.data!.docs;
//
//                       // Filter patients based on search query
//                       var filteredPatients = patients.where((doc) {
//                         var patient = doc.data() as Map<String, dynamic>;
//                         return patient['fullName']
//                                     ?.toLowerCase()
//                                     .contains(_searchQuery.toLowerCase()) ==
//                                 true ||
//                             patient['email']
//                                     ?.toLowerCase()
//                                     .contains(_searchQuery.toLowerCase()) ==
//                                 true ||
//                             patient['disability']
//                                     ?.toLowerCase()
//                                     .contains(_searchQuery.toLowerCase()) ==
//                                 true;
//                       }).toList();
//
//                       return Container(
//                         width: double.maxFinite,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.grey.shade300, blurRadius: 5)
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Table(
//                               columnWidths: const {
//                                 0: FlexColumnWidth(5),
//                                 1: FlexColumnWidth(2),
//                                 2: FlexColumnWidth(2),
//                                 3: FlexColumnWidth(2),
//                                 4: FlexColumnWidth(3),
//                                 5: FlexColumnWidth(2),
//                               },
//                               children: [
//                                 TableRow(
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.shade200),
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                           'patient'.tr, // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('disability'.tr,
//                                           // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                           'gender'.tr, // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                           'status'.tr, // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text('registration'.tr,
//                                           // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                           'actions'.tr, // Use translation key
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const Divider(height: 1, color: Colors.grey),
//                             const Divider(height: 1, color: Colors.grey),
//                             SizedBox(
//                               height: 500,
//                               child: ListView.builder(
//                                 itemCount: filteredPatients.length,
//                                 itemBuilder: (context, index) {
//                                   var patient = filteredPatients[index].data()
//                                       as Map<String, dynamic>;
//                                   var patientId = filteredPatients[index].id;
//
//                                   return Table(
//                                     columnWidths: const {
//                                       0: FlexColumnWidth(4),
//                                       1: FlexColumnWidth(2),
//                                       2: FlexColumnWidth(2),
//                                       3: FlexColumnWidth(2),
//                                       4: FlexColumnWidth(3),
//                                       5: FlexColumnWidth(2),
//                                     },
//                                     children: [
//                                       TableRow(
//                                         decoration: BoxDecoration(
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   color: Colors.grey.shade300)),
//                                         ),
//                                         children: [
//                                           // Patient Name & Email
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(patient['fullName'] ?? '',
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 13),
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                                 Text(patient['email'] ?? '',
//                                                     style: const TextStyle(
//                                                         color: Colors.grey,
//                                                         fontSize: 13),
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                               ],
//                                             ),
//                                           ),
//                                           // Disability
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Chip(
//                                               label: Text(
//                                                   patient['disability'] ?? '',
//                                                   style: const TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.white)),
//                                               backgroundColor:
//                                                   AppTheme.lightGreen,
//                                             ),
//                                           ),
//                                           // Gender
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Chip(
//                                               label: Text(
//                                                 patient['gender']
//                                                             ?.toLowerCase() ==
//                                                         'male'
//                                                     ? 'male'.tr
//                                                     : 'female'.tr,
//                                                 // Use translation key
//                                                 style: TextStyle(
//                                                   fontSize: 13,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               backgroundColor:
//                                                   (patient['gender']
//                                                               ?.toLowerCase() ==
//                                                           'male')
//                                                       ? Colors.black
//                                                       : Colors.blue,
//                                             ),
//                                           ),
//
//                                           // Status
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Chip(
//                                               label: Text(
//                                                   patient['status'] ?? '',
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.white)),
//                                               backgroundColor:
//                                                   AppTheme.lightGreen,
//                                             ),
//                                           ),
//                                           // Registration Date
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 const Icon(Icons.calendar_today,
//                                                     size: 13),
//                                                 const SizedBox(width: 4),
//                                                 Text(
//                                                   patient['regDate']
//                                                           is Timestamp
//                                                       ? (patient['regDate']
//                                                               as Timestamp)
//                                                           .toDate()
//                                                           .toLocal()
//                                                           .toString()
//                                                           .split(' ')[0]
//                                                       : patient['regDate'] ??
//                                                           '',
//                                                   style: const TextStyle(
//                                                       fontSize: 13),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           // Actions
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 50),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                       Icons.remove_red_eye,
//                                                       color: Colors.blue,
//                                                       size: 13),
//                                                   onPressed: () {
//                                                     Get.to(() => MainLayout(
//                                                         child:
//                                                             PatientViewScreen(
//                                                                 patient:
//                                                                     patient)));
//                                                   },
//                                                 ),
//                                                 IconButton(
//                                                   icon: const Icon(Icons.delete,
//                                                       color: Colors.red,
//                                                       size: 13),
//                                                   onPressed: () {
//                                                     FirebaseFirestore.instance
//                                                         .collection('patients')
//                                                         .doc(patientId)
//                                                         .delete();
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
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
