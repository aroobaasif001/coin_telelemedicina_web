import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/Provinces/addProvincesScreen/add_province_screen.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboardScreen/widget/top_nav_bar_widget.dart';
import 'controller/province_controller.dart';

class ProvinceScreen extends StatelessWidget {
  final ProvinceController provinceController = Get.put(ProvinceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: Column(
        children: [
          CustomContainer(
            conColor: Colors.white,
            margin: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('provinces_and_municipalities'.tr, // Use translation key
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MainLayout(child: AddProvinceScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                text: 'new_province'.tr, // Use translation key
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Filters Section
                Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'search_hint'.tr, // Use translation key
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (value) => provinceController.searchQuery.value = value,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => DropdownButton<String>(
                        value: provinceController.selectedProvinceFilter.value.isEmpty
                            ? null
                            : provinceController.selectedProvinceFilter.value,
                        hint: Text('select_province'.tr), // Use translation key
                        isExpanded: true,
                        items: provinceController.provinces
                            .map((province) => DropdownMenuItem<String>(
                          value: province["id"] as String,
                          child: Text(province["name"] as String),
                        ))
                            .toList(),
                        onChanged: (value) {
                          provinceController.selectedProvinceFilter.value = value ?? "";
                          provinceController.fetchMunicipalities(value!);
                        },
                      )),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => DropdownButton<String>(
                        value: provinceController.selectedMunicipalityFilter.value.isEmpty
                            ? null
                            : provinceController.selectedMunicipalityFilter.value,
                        hint: Text("select_municipality".tr),
                        isExpanded: true,
                        items: provinceController.municipalities[
                        provinceController.selectedProvinceFilter.value] != null
                            ? provinceController.municipalities[
                        provinceController.selectedProvinceFilter.value]!
                            .map<DropdownMenuItem<String>>((municipality) =>
                            DropdownMenuItem<String>(
                              value: municipality["id"] as String,
                              child: Text(municipality["name"] as String),
                            ))
                            .toList()
                            : [],
                        onChanged: (value) {
                          provinceController.selectedMunicipalityFilter.value = value ?? "";
                        },
                      )),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        provinceController.searchQuery.value = '';
                        provinceController.selectedProvinceFilter.value = '';
                        provinceController.selectedMunicipalityFilter.value = '';
                      },
                      child: Text('clear'.tr), // Use translation key
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Obx(() => Text("${provinceController.filteredProvinces.length} provinces found")),
              ],
            ),
          ),
          Expanded(
            child: CustomContainer(
              conColor: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provinceController.filteredProvinces.length,
                    itemBuilder: (context, index) {
                      var province = provinceController.filteredProvinces[index];
                      return CustomContainer(
                        conColor: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    province["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${province["municipalities"]} municipalities",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _editProvinceDialog(context, province);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      provinceController.deleteProvince(province["id"]);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          leading: Icon(Icons.location_city, color: Colors.green),
                          children: [
                            Obx(() {
                              var municipalitiesList = provinceController.municipalities[province["id"]] ?? [];
                              return Column(
                                children: municipalitiesList
                                    .map((municipality) => ListTile(
                                  title: Text(municipality["name"]),
                                  leading: Icon(Icons.apartment, color: Colors.blue),
                                ))
                                    .toList(),
                              );
                            }),
                          ],
                          onExpansionChanged: (isExpanded) {
                            if (isExpanded) {
                              provinceController.fetchMunicipalities(province["id"]);
                            }
                          },
                        ),
                      );
                    },
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

void _editProvinceDialog(BuildContext context, Map<String, dynamic> province) {
  TextEditingController nameController = TextEditingController(text: province["name"]);
  TextEditingController municipalityController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit Province"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Province Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter province name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Text("Add Municipality",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: municipalityController,
                decoration: InputDecoration(
                  hintText: "Enter municipality name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await provinceController.updateProvince(
                  province["id"],
                  nameController.text.trim(),
                );
                if (municipalityController.text.isNotEmpty) {
                  await provinceController.addMunicipality(
                    province["id"],
                    municipalityController.text.trim(),
                  );
                }
                Navigator.pop(context);
              } else {
                Get.snackbar("Error", "Please enter a province name!");
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}
}