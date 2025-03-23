import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/interpreter_model.dart';
import 'package:get/get.dart'; // Import GetX

class InterpreterDetailScreen extends StatelessWidget {
  final InterpreterModel interpreter;
  InterpreterDetailScreen({required this.interpreter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(
              isLeading: true,
              title: 'interpreter_detail'.tr, // Translated title
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image and Name
                  CustomContainer(
                    conColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: interpreter.photoUrl.isNotEmpty
                                ? NetworkImage(interpreter.photoUrl)
                                : AssetImage('assets/img.png') as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          interpreter.fullName,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Details Card
                  Expanded(
                    child: CustomContainer(
                      conColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.person, "full_name".tr, interpreter.fullName),
                          _buildDetailRow(Icons.school, "education".tr, interpreter.education),
                          _buildDetailRow(Icons.timer, "experience".tr, "${interpreter.experience} ${'years'.tr}"),
                          _buildDetailRow(Icons.language, "languages".tr, interpreter.languages.join(', ')),
                          _buildDetailRow(Icons.translate, "interpreter_types".tr, interpreter.interpreterTypes.join(', ')),
                          _buildDetailRow(Icons.star, "rating".tr, "${interpreter.rating} ⭐"),
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