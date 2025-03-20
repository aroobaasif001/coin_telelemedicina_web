import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widget/CustomText.dart';
import 'controller/add_province_controller.dart';

class AddProvinceScreen extends StatelessWidget {
  final AddProvinceController firestoreController =
      Get.put(AddProvinceController());

  final TextEditingController provinceController = TextEditingController();
  final TextEditingController municipalityController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Manage Provinces",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: "Add Province",
                icon: Icons.location_city,
                iconColor: AppTheme.primaryColor,
                controller: provinceController,
                hintText: "Enter Province Name",
                buttonLabel: "Add Province",
                buttonColor: AppTheme.primaryColor,
                onPressed: () {
                  if (provinceController.text.isNotEmpty) {
                    firestoreController
                        .addProvince(provinceController.text.trim());
                    provinceController.clear();
                  } else {
                    Get.snackbar("Error", "Please enter a province name!");
                  }
                },
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Municipality",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      SizedBox(height: 10),
                      Obx(() {
                        return _buildDropdown(
                          items: firestoreController.provinces,
                          value:
                              firestoreController.selectedProvince.value.isEmpty
                                  ? null
                                  : firestoreController.selectedProvince.value,
                          hint: "Select Province",
                          icon: Icons.map,
                          iconColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            firestoreController.selectedProvince.value =
                                value ?? "";
                            firestoreController.fetchMunicipalities(value!);
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      _buildTextField(
                          municipalityController,
                          "Enter Municipality Name",
                          Icons.business,
                          Colors.green),
                      SizedBox(height: 10),
                      _buildElevatedButton(
                        label: "Add Municipality",
                        icon: Icons.add,
                        color: AppTheme.primaryColor,
                        onPressed: () {
                          if (firestoreController
                                  .selectedProvince.value.isNotEmpty &&
                              municipalityController.text.isNotEmpty) {
                            firestoreController.addMunicipality(
                              firestoreController.selectedProvince.value,
                              municipalityController.text.trim(),
                            );
                            municipalityController.clear();
                          } else {
                            Get.snackbar("Error",
                                "Select a province & enter a municipality name!");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Sector",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                      SizedBox(height: 10),
                      Obx(() {
                        return _buildDropdown(
                          items: firestoreController.municipalities,
                          value: firestoreController
                                  .selectedMunicipality.value.isEmpty
                              ? null
                              : firestoreController.selectedMunicipality.value,
                          hint: "Select Municipality",
                          icon: Icons.location_on,
                          iconColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            firestoreController.selectedMunicipality.value =
                                value ?? "";
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      _buildTextField(sectorController, "Enter Sector Name",
                          Icons.apartment, AppTheme.primaryColor),
                      SizedBox(height: 10),
                      _buildElevatedButton(
                        label: "Add Sector",
                        icon: Icons.add,
                        color: AppTheme.primaryColor,
                        onPressed: () {
                          if (firestoreController
                                  .selectedMunicipality.value.isNotEmpty &&
                              sectorController.text.isNotEmpty) {
                            firestoreController.addSector(
                              firestoreController.selectedProvince.value,
                              firestoreController.selectedMunicipality.value,
                              sectorController.text.trim(),
                            );
                            sectorController.clear();
                          } else {
                            Get.snackbar("Error",
                                "Select a municipality & enter a sector name!");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
    required String hintText,
    required String buttonLabel,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: iconColor)),
            SizedBox(height: 10),
            _buildTextField(controller, hintText, icon, iconColor),
            SizedBox(height: 10),
            _buildElevatedButton(
                label: buttonLabel,
                icon: Icons.add,
                color: buttonColor,
                onPressed: onPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      IconData icon, Color iconColor) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon, color: iconColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdown({
    required List<Map<String, dynamic>> items,
    required String? value,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(icon, color: iconColor),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item["id"],
          child: Text(item["name"]),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildElevatedButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: label,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
