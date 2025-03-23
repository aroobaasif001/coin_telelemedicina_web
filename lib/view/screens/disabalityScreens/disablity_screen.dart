import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/disabalityScreens/addDisabailityScreen/add_disabaility_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/AppTheme.dart';
import '../../../widget/CustomText.dart';
import '../dashboardScreen/widget/top_nav_bar_widget.dart';
import 'controller/disbality_controller.dart';

class DisabilityScreen extends StatelessWidget {
  final DisabilityController disabilityController = Get.put(DisabilityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: Column(
        spacing: 10,
        children: [
          CustomContainer(
            conColor: Colors.white,
            margin: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('provinces_and_municipalities'.tr, // Use translation key
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MainLayout(child: AddDisabilityScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
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
                                text: 'add_disability'.tr, // Use translation key
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (value) => disabilityController.searchQuery.value = value,
                      ),
                    ),
                    SizedBox(width: 10),
                    // Disability Filter Dropdown
                    Expanded(
                      child: Obx(() => DropdownButton<String>(
                        value: disabilityController.selectedDisabilityFilter.value.isEmpty
                            ? null
                            : disabilityController.selectedDisabilityFilter.value,
                        hint: Text('select_disability'.tr), // Use translation key
                        isExpanded: true,
                        items: disabilityController.disabilities
                            .map((disability) => DropdownMenuItem<String>(
                          value: disability["id"],
                          child: Text(disability["name"]),
                        ))
                            .toList(),
                        onChanged: (value) =>
                        disabilityController.selectedDisabilityFilter.value = value ?? "",
                      )),
                    ),
                    SizedBox(width: 10),
                    // Type Filter Dropdown
                    Expanded(
                      child: Obx(
                            () => DropdownButton<String>(
                          value: disabilityController.selectedTypeFilter.value.isEmpty
                              ? null
                              : disabilityController.selectedTypeFilter.value,
                          hint: Text('select_type'.tr), // Use translation key
                          isExpanded: true,
                          items: disabilityController.types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type["id"],
                              child: Text(type["name"]),
                            );
                          }).toList(),
                          onChanged: (value) => disabilityController.selectedTypeFilter.value = value ?? "",
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Clear Filters Button
                    ElevatedButton(
                      onPressed: () {
                        disabilityController.searchQuery.value = '';
                        disabilityController.selectedDisabilityFilter.value = '';
                        disabilityController.selectedTypeFilter.value = '';
                      },
                      child: Text('clear'.tr), // Use translation key
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Disability Count
                Obx(() => Text(
                    "${disabilityController.filteredDisabilities.length} ${'disabilities_found'.tr}")), // Use translation key
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
                child: Expanded(
                  child: Obx(() => ListView.builder(
                    itemCount: disabilityController.filteredDisabilities.length,
                    itemBuilder: (context, index) {
                      var disability = disabilityController.filteredDisabilities[index];
                      return CustomContainer(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        borderRadius: BorderRadius.circular(10),
                        conColor: Colors.white,
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(FontAwesomeIcons.wheelchair, color: Colors.green),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(disability["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text("${disability["types"]} ${'types'.tr}"), // Use translation key
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black54),
                                  onPressed: () {
                                    // TODO: Implement Edit Disability
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      disabilityController.deleteDisability(disability["id"]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}