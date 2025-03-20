import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/CustomText.dart';
import 'add_disability_controller.dart';

class AddDisabilityScreen extends StatelessWidget {
  final AddDisabilityController disabilityController =
      Get.put(AddDisabilityController());

  final TextEditingController disabilityNameController =
      TextEditingController();
  final TextEditingController disabilityTypeNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Add Disabilities & Types",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Disability",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                      SizedBox(height: 10),
                      TextField(
                        controller: disabilityNameController,
                        decoration: InputDecoration(
                          labelText: "Enter Disability Name",
                          prefixIcon: Icon(Icons.accessibility_new,
                              color: AppTheme.primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (disabilityNameController.text.isNotEmpty) {
                            disabilityController.addDisability(
                                disabilityNameController.text.trim());
                            disabilityNameController.clear();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12)),
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
                            
                                  text: 'Add Disability',
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
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
                      Text("Add Disability Type",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                      SizedBox(height: 10),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: disabilityController
                                  .selectedDisability.value.isEmpty
                              ? null
                              : disabilityController.selectedDisability.value,
                          hint: Text("Select Disability"),
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            prefixIcon:
                                Icon(Icons.list_alt, color: Colors.green),
                          ),
                          items: disabilityController.disabilities
                              .map((disability) {
                            return DropdownMenuItem<String>(
                              value: disability["id"],
                              child: Text(disability["name"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            disabilityController.selectedDisability.value =
                                value ?? "";
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      TextField(
                        controller: disabilityTypeNameController,
                        decoration: InputDecoration(
                          labelText: "Enter Disability Type Name",
                          prefixIcon: Icon(Icons.category, color: Colors.green),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (disabilityController
                                  .selectedDisability.value.isNotEmpty &&
                              disabilityTypeNameController.text.isNotEmpty) {
                            disabilityController.addDisabilityType(
                              disabilityController.selectedDisability.value,
                              disabilityTypeNameController.text.trim(),
                            );
                            disabilityTypeNameController.clear();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: 'Add Disability Type',
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
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
}
