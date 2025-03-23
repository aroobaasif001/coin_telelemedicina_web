import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';
import 'package:get/get.dart'; // Import GetX

class DoctorDetailScreen extends StatelessWidget {
  final ProviderModel doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(
              isLeading: true,
              title: 'doctor_detail'.tr, // Translated title
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    conColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Doctor Profile Image
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: doctor.photoUrl.isNotEmpty
                                ? NetworkImage(doctor.photoUrl)
                                : AssetImage('assets/img.png') as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Doctor Name
                        Text(
                          doctor.fullName,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomContainer(
                      conColor: Colors.white,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.person, "full_name".tr, doctor.fullName),
                          _buildDetailRow(Icons.medical_services, "specialty".tr, doctor.specialty),
                          _buildDetailRow(Icons.timer, "experience".tr, "${doctor.experience} ${'years'.tr}"),
                          _buildDetailRow(Icons.info_outline, "biography".tr, doctor.biography),
                          _buildDetailRow(Icons.school, "education".tr, doctor.education),
                          _buildDetailRow(Icons.language, "languages".tr, doctor.languages.join(', ')),
                          _buildDetailRow(Icons.star, "rating".tr, "${doctor.rating} ⭐ (${doctor.reviewCount} ${'reviews'.tr})"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}