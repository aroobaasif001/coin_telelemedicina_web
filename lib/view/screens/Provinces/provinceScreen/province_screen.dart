import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/screens/Provinces/addProvincesScreen/add_province_screen.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Provinces & Municipalities",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Get.to(() => AddProvinceScreen());
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
                            text: 'New Province',
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
                      hintText: "Search by name...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) =>
                        provinceController.searchQuery.value = value,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                        value: provinceController
                                .selectedProvinceFilter.value.isEmpty
                            ? null
                            : provinceController.selectedProvinceFilter.value,
                        hint: Text("Select Province"),
                        isExpanded: true,
                        items: provinceController.provinces
                            .map((province) => DropdownMenuItem<String>(
                                  value: province["id"] as String,
                                  child: Text(province["name"] as String),
                                ))
                            .toList(),
                        onChanged: (value) {
                          provinceController.selectedProvinceFilter.value =
                              value ?? "";
                          provinceController.fetchMunicipalities(
                              value!); // 🔥 Fetch municipalities when province is selected
                        },
                      )),
                ),
                SizedBox(width: 10),

// 🔥 Municipality Dropdown (Fix)
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                        value: provinceController
                                .selectedMunicipalityFilter.value.isEmpty
                            ? null
                            : provinceController
                                .selectedMunicipalityFilter.value,
                        hint: Text("Select Municipality"),
                        isExpanded: true,
                        items: provinceController.municipalities[
                                    provinceController
                                        .selectedProvinceFilter.value] !=
                                null
                            ? provinceController.municipalities[
                                    provinceController
                                        .selectedProvinceFilter.value]!
                                .map<DropdownMenuItem<String>>((municipality) =>
                                    DropdownMenuItem<String>(
                                      value: municipality["id"] as String,
                                      child:
                                          Text(municipality["name"] as String),
                                    ))
                                .toList()
                            : [], // 🔥 Show municipalities for the selected province
                        onChanged: (value) {
                          provinceController.selectedMunicipalityFilter.value =
                              value ?? "";
                        },
                      )),
                ),

                SizedBox(width: 10),

                // Clear Filters Button
                ElevatedButton(
                  onPressed: () {
                    provinceController.searchQuery.value = '';
                    provinceController.selectedProvinceFilter.value = '';
                    provinceController.selectedMunicipalityFilter.value = '';
                  },
                  child: Text("Clear"),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Province Count
            Obx(() => Text(
                "${provinceController.filteredProvinces.length} provinces found")),

            // Province List
            /// **📌 Province List with Expandable Municipalities**
            Obx(() => Expanded(
                  child: ListView.builder(
                    itemCount: provinceController.filteredProvinces.length,
                    itemBuilder: (context, index) {
                      var province =
                          provinceController.filteredProvinces[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// **🏙 Province Name & Municipality Count**
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    province["name"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${province["municipalities"]} municipalities",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              /// **✏️ Edit & ❌ Delete Buttons**
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      // TODO: Implement Edit Functionality
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      provinceController
                                          .deleteProvince(province["id"]);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          leading:
                              Icon(Icons.location_city, color: Colors.green),

                          /// **📍 Expandable Municipalities List**
                          children: [
                            Obx(() {
                              // Get the list of municipalities for the selected province
                              var municipalitiesList = provinceController
                                      .municipalities[province["id"]] ??
                                  [];

                              return Column(
                                children: municipalitiesList
                                    .map((municipality) => ListTile(
                                          title: Text(municipality["name"]),
                                          leading: Icon(Icons.apartment,
                                              color: Colors.blue),
                                        ))
                                    .toList(),
                              );
                            }),
                          ],
                          onExpansionChanged: (isExpanded) {
                            if (isExpanded) {
                              provinceController
                                  .fetchMunicipalities(province["id"]);
                            }
                          },
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
