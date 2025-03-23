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
        title: Text("manage_provinces".tr,
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
                title: "add_province".tr,
                icon: Icons.location_city,
                iconColor: AppTheme.primaryColor,
                controller: provinceController,
                hintText: "enter_province_name".tr,
                buttonLabel: "add_province".tr,
                buttonColor: AppTheme.primaryColor,
                onPressed: () {
                  if (provinceController.text.isNotEmpty) {
                    firestoreController
                        .addProvince(provinceController.text.trim());
                    provinceController.clear();
                  } else {
                    Get.snackbar("error".tr, "please_enter_province_name".tr);
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
                      Text("add_municipality".tr,
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
                          hint: "select_province".tr,
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
                          "enter_municipality_name".tr,
                          Icons.business,
                          Colors.green),
                      SizedBox(height: 10),
                      _buildElevatedButton(
                        label: "add_municipality".tr,
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
                            Get.snackbar("error".tr,
                                "please_select_province_and_enter_municipality_name".tr);
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
                      Text("add_sector".tr,
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
                          hint: "select_municipality".tr,
                          icon: Icons.location_on,
                          iconColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            firestoreController.selectedMunicipality.value =
                                value ?? "";
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      _buildTextField(sectorController, "enter_sector_name".tr,
                          Icons.apartment, AppTheme.primaryColor),
                      SizedBox(height: 10),
                      _buildElevatedButton(
                        label: "add_sector".tr,
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
                            Get.snackbar("error".tr,
                                "please_select_municipality_and_enter_sector_name".tr);
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