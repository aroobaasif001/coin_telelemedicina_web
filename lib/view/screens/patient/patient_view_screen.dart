import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/components/app_colors.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
            CustomAppbar(isLeading: true, title: 'patient_management'.tr),
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
                              _buildInfoCard("personal_information".tr, [
                                _infoField("id_document".tr, patient['id']),
                                _infoField("phone".tr, patient['phone']),
                                _infoField("birthdate".tr, patient['dob']),
                                _infoField("province".tr, patient['province']),
                                _infoField("status".tr, patient['status']),
                                _infoField("disability".tr, patient['disability']),
                              ]),
                              const SizedBox(height: 16),
                              _buildInfoCard("additional_information".tr, [
                                _infoField("registration_date".tr, formatTimestamp(patient['regDate'])),
                                _infoField("last_update".tr, patient['lastUpdate']),
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
                            tabs: [
                              Tab(text: "upcoming_consultations".tr),
                              Tab(text: "history".tr),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: TabBarView(
                              children: [
                                // Upcoming Consultations Tab
                                _buildConsultationList(
                                  FirebaseFirestore.instance
                                      .collection('appointments')
                                      .where('patientId', isEqualTo: patient['patientId'])
                                      .where('date', isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
                                      .orderBy('date', descending: false)
                                      .snapshots(),
                                ),
                                // History Tab
                                _buildConsultationList(
                                  FirebaseFirestore.instance
                                      .collection('appointments')
                                      .where('patientId', isEqualTo: patient['patientId'])
                                      .where('date', isLessThan: DateTime.now().toIso8601String())
                                      .orderBy('date', descending: true)
                                      .snapshots(),
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

  Widget _buildConsultationList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: CustomText(text: "Error loading data"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: CustomText(
              text: "No data available",
              color: Colors.grey[600],
            ),
          );
        }

        var appointments = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            var appointment = appointments[index].data() as Map<String, dynamic>;
            return _buildConsultationItem(appointment);
          },
        );
      },
    );
  }

  Widget _buildConsultationItem(Map<String, dynamic> appointment) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: CustomText(
          text: appointment['service'] ?? "N/A",
          fontWeight: FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Date: ${formatTimestamp(appointment['date'])}",
              fontSize: 14,
              color: Colors.grey[700],
            ),
            CustomText(
              text: "Time: ${appointment['time'] ?? "N/A"}",
              fontSize: 14,
              color: Colors.grey[700],
            ),
            CustomText(
              text: "Status: ${appointment['status'] ?? "N/A"}",
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('MMMM dd, yyyy').format(timestamp.toDate());
    } else if (timestamp is String) {
      return DateFormat('MMMM dd, yyyy').format(DateTime.parse(timestamp));
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