import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/health_center_model.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:get/get.dart'; // Import GetX

class HealthCenterDetailScreen extends StatelessWidget {
  final HealthCenterModel center;

  HealthCenterDetailScreen({required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          center.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🏥 Health Center Name
            Text(
              center.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(thickness: 1, height: 24),

            // 📌 Health Center Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.location_on, "address".tr, center.address),
                    _buildDetailRow(Icons.location_city, "city".tr, center.city),
                    _buildDetailRow(Icons.phone, "phone".tr, center.phone),
                    _buildDetailRow(Icons.email, "email".tr, center.email),
                    _buildDetailRow(Icons.web, "website".tr, center.website),
                    _buildDetailRow(Icons.description, "description".tr, center.description),
                    _buildDetailRow(Icons.map, "latitude".tr, center.latitude.toString()),
                    _buildDetailRow(Icons.map, "longitude".tr, center.longitude.toString()),
                    _buildDetailRow(
                      Icons.check_circle,
                      "status".tr,
                      center.isActive ? "active".tr : "inactive".tr,
                      textColor: center.isActive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🕒 Availability Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🕒 ${'availability'.tr}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    ...center.availability.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${entry.key.toUpperCase()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text("${'open'.tr}: ${entry.value['open'] ?? 'closed'.tr}"),
                            SizedBox(width: 10),
                            Text("${'close'.tr}: ${entry.value['close'] ?? 'closed'.tr}"),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? textColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16, color: textColor ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}