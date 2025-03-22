
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coin_telelemedicina_web/components/app_colors.dart';
// import 'package:coin_telelemedicina_web/widget/CustomText.dart';
// import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class PatientViewScreen extends StatelessWidget {
//   final Map<String, dynamic> patient;
//   const PatientViewScreen({Key? key, required this.patient}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         body: Column(
//           children: [
//             CustomAppbar(isLeading: true, title: 'Patient Profile'),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 300,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 blurRadius: 4,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 50,
//                                   backgroundImage: NetworkImage(
//                                       patient['photoUrl'] ??
//                                           "https://via.placeholder.com/150"),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 CustomText(
//                                   text: patient['fullName'] ?? "N/A",
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 CustomText(
//                                   text: patient['email'] ?? "N/A",
//                                   color: Colors.grey[700],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               _buildInfoCard("Personal Information", [
//                                 _infoField(
//                                     label: "ID / Document",
//                                     value: patient['documentId'] ?? "N/A"),
//                                 _infoField(
//                                     label: "Phone",
//                                     value: patient['phone'] ?? "N/A"),
//                                 _infoField(
//                                     label: "Birthdate",
//                                     value: patient['dob'] ?? "N/A"),
//                                 _infoField(
//                                     label: "Province",
//                                     value: patient['province'] ?? "N/A"),
//                                 _infoField(
//                                     label: "Status",
//                                     value: patient['status'] ?? "N/A"),
//                                 _infoField(
//                                     label: "Disability",
//                                     value: patient['disability'] ?? "N/A"),
//                               ]),
//                               const SizedBox(height: 20),
//                               _buildInfoCard("Additional Information", [
//                                 _infoField(
//                                     label: "Registration Date",
//                                     value: formatTimestamp(patient['regDate'])),
//                                 _infoField(
//                                     label: "Last Update",
//                                     value: patient['lastUpdate'] ?? "N/A"),
//                               ]),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     // Container(
//                     //   height: 60,
//                     //   padding: const EdgeInsets.all(10),
//                     //   decoration: BoxDecoration(
//                     //     color: Colors.grey[200],
//                     //     borderRadius: BorderRadius.circular(10),
//                     //   ),
//                     //   child: TabBar(
//                     //     labelColor: Colors.black,
//                     //     isScrollable: true,
//                     //     dividerColor: Colors.transparent,
//                     //     indicatorColor: AppColor.greenColor,
//                     //     tabs: const [
//                     //       Tab(text: "Upcoming Consultations"),
//                     //       Tab(text: "History"),
//                     //     ],
//                     //   ),
//                     // ),
//                     const SizedBox(height: 8),
//                     // SizedBox(
//                     //   height: 200,
//                     //   child: TabBarView(
//                     //     children: [
//                     //       Center(
//                     //         child: CustomText(
//                     //           text: "No scheduled consultations",
//                     //           color: Colors.grey[600],
//                     //         ),
//                     //       ),
//                     //       Center(
//                     //         child: CustomText(
//                     //           text: "No history available",
//                     //           color: Colors.grey[600],
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return DateFormat('MMMM dd, yyyy').format(timestamp.toDate());
//     } else {
//       return timestamp?.toString() ?? "N/A";
//     }
//   }

//   Widget _buildInfoCard(String title, List<Widget> children) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               text: title,
//               fontWeight: FontWeight.bold,
//             ),
//             const Divider(),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoField({required String label, required String value}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: label,
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           const SizedBox(height: 4),
//           CustomText(
//             text: value,
//             fontSize: 14,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/components/app_colors.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientViewScreen extends StatelessWidget {
  final Map<String, dynamic> patient;
  const PatientViewScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            CustomAppbar(isLeading: true, title: 'Patient Profile'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          conColor: Colors.white,
                          padding: EdgeInsets.all(15),
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                    patient['profileImage'] ?? "https://via.placeholder.com/150"),
                              ),
                              const SizedBox(height: 12),
                              CustomText(
                                text: patient['fullName'] ?? "N/A",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: patient['email'] ?? "N/A",
                                color: Colors.grey[700],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildInfoCard("Personal Information", [
                                _infoField("ID / Document", patient['id']),
                                _infoField("Phone", patient['phone']),
                                _infoField("Birthdate", patient['dob']),
                                _infoField("Province", patient['province']),
                                _infoField("Status", patient['status']),
                                _infoField("Disability", patient['disability']),
                              ]),
                              const SizedBox(height: 16),
                              _buildInfoCard("Additional Information", [
                                _infoField("Registration Date", formatTimestamp(patient['regDate'])),
                                _infoField("Last Update", patient['lastUpdate']),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomContainer(
                        conColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppColor.greenColor,
                            tabs: const [
                              Tab(text: "Upcoming Consultations"),
                              Tab(text: "History"),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: TabBarView(
                              children: [
                                Center(
                                  child: CustomText(
                                    text: "No scheduled consultations",
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Center(
                                  child: CustomText(
                                    text: "No history available",
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('MMMM dd, yyyy').format(timestamp.toDate());
    } else {
      return timestamp?.toString() ?? "N/A";
    }
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return CustomContainer(
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 4),
          CustomText(
            text: value ?? "N/A",
            fontSize: 14,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
