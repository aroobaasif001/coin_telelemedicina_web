import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/components/app_colors.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DoctorDetailScreen extends StatelessWidget {
  final ProviderModel doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            CustomAppbar(isLeading: true, title: 'doctor_detail'.tr),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Profile Card
                        CustomContainer(
                          conColor: Colors.white,
                          padding: EdgeInsets.all(15),
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: doctor.photoUrl.isNotEmpty
                                    ? NetworkImage(doctor.photoUrl)
                                    : null,
                                child: doctor.photoUrl.isEmpty
                                    ? Icon(Icons.person, size: 50, color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              CustomText(
                                text: doctor.fullName,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: doctor.specialty,
                                color: Colors.grey[700],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Doctor Information
                        Expanded(
                          child: Column(
                            children: [
                              _buildInfoCard("professional_information".tr, [
                                _infoField("specialty".tr, doctor.specialty),
                                _infoField("experience".tr, "${doctor.experience} ${'years'.tr}"),
                                _infoField("education".tr, doctor.education),
                                _infoField("languages".tr, doctor.languages.join(', ')),
                                _infoField("rating".tr, "${doctor.rating} ⭐ (${doctor.reviewCount} ${'reviews'.tr})"),
                              ]),
                              const SizedBox(height: 16),
                              _buildInfoCard("additional_information".tr, [
                                _infoField("biography".tr, doctor.biography),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Appointments Tab View
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
                            tabs: [
                              Tab(text: "upcoming_consultations".tr),
                              Tab(text: "history".tr),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                _buildUpcomingAppointments(),
                                _buildAppointmentHistory(),
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

  Widget _buildUpcomingAppointments() {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('providerId', isEqualTo: doctor.docId)
          // .where('dateString', isGreaterThanOrEqualTo: today)
          // .orderBy('dateString')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorState('Failed to load upcoming appointments: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No upcoming appointments found');
        }

        // Client-side filtering for status
        var appointments = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return ['scheduled', 'confirmed', 'pending'].contains(data['status']);
        }).toList();

        if (appointments.isEmpty) {
          return _buildEmptyState('No upcoming appointments found');
        }

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            var appointment = appointments[index].data() as Map<String, dynamic>;
            return _buildAppointmentItem(appointment);
          },
        );
      },
    );
  }

  Widget _buildAppointmentHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('providerId', isEqualTo:doctor.docId)
          // .orderBy('dateString', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorState('Failed to load appointment history: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No appointment history found');
        }

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var appointment = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return _buildAppointmentItem(appointment);
          },
        );
      },
    );
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appointment) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Icon(Icons.calendar_today, color: AppColor.greenColor),
        title: CustomText(
          text: appointment['service'] ?? "N/A",
          fontWeight: FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.date_range, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                CustomText(
                  text: formatTimestamp(appointment['date']),
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                CustomText(
                  text: appointment['time'] ?? "N/A",
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                CustomText(
                  text: appointment['patientName'] ?? "N/A",
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.info, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                CustomText(
                  text: appointment['status']?.toString().capitalizeFirst ?? "N/A",
                  fontSize: 14,
                  color: _getStatusColor(appointment['status']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 8),
          CustomText(
            text: message,
            color: Colors.red,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: Colors.grey, size: 48),
          SizedBox(height: 8),
          CustomText(
            text: message,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'scheduled':
        return Colors.blue;
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('MMMM dd, yyyy').format(timestamp.toDate());
    } else if (timestamp is String) {
      try {
        return DateFormat('MMMM dd, yyyy').format(DateTime.parse(timestamp));
      } catch (e) {
        return timestamp?.toString() ?? "N/A";
      }
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



///

// import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
// import 'package:coin_telelemedicina_web/widget/custom_container.dart';
// import 'package:flutter/material.dart';
// import 'package:coin_telelemedicina_web/model/provider_model.dart';
// import 'package:get/get.dart'; // Import GetX
//
// class DoctorDetailScreen extends StatelessWidget {
//   final ProviderModel doctor;
//
//   DoctorDetailScreen({required this.doctor});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CustomAppbar(
//               isLeading: true,
//               title: 'doctor_detail'.tr, // Translated title
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomContainer(
//                     conColor: Colors.white,
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         // Doctor Profile Image
//                         Center(
//                           child: CircleAvatar(
//                             radius: 60,
//                             backgroundColor: Colors.grey[300],
//                             backgroundImage: doctor.photoUrl.isNotEmpty
//                                 ? NetworkImage(doctor.photoUrl)
//                                 : AssetImage('assets/img.png') as ImageProvider,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//
//                         // Doctor Name
//                         Text(
//                           doctor.fullName,
//                           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: CustomContainer(
//                       conColor: Colors.white,
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildDetailRow(Icons.person, "full_name".tr, doctor.fullName),
//                           _buildDetailRow(Icons.medical_services, "specialty".tr, doctor.specialty),
//                           _buildDetailRow(Icons.timer, "experience".tr, "${doctor.experience} ${'years'.tr}"),
//                           _buildDetailRow(Icons.info_outline, "biography".tr, doctor.biography),
//                           _buildDetailRow(Icons.school, "education".tr, doctor.education),
//                           _buildDetailRow(Icons.language, "languages".tr, doctor.languages.join(', ')),
//                           _buildDetailRow(Icons.star, "rating".tr, "${doctor.rating} ⭐ (${doctor.reviewCount} ${'reviews'.tr})"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 24, color: Colors.blueGrey),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               "$label: $value",
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }