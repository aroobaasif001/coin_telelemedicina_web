import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/dashboardScreen/widget/top_nav_bar_widget.dart';
import 'package:coin_telelemedicina_web/view/screens/disabalityScreens/controller/disbality_controller.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'addDisabailityScreen/add_disabaility_screen.dart';

class DisabilityScreen extends StatelessWidget {
  final DisabilityController disabilityController =
      Get.find<DisabilityController>();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('provinces_and_municipalities'.tr,
                        // Use translation key
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MainLayout(child: AddDisabilityScreen()));
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
                                text: 'add_disability'.tr,
                                // Use translation key
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
                        onChanged: (value) =>
                            disabilityController.searchQuery.value = value,
                      ),
                    ),
                    SizedBox(width: 10),
                    // Disability Filter Dropdown
                    Expanded(
                      child: Obx(() => DropdownButton<String>(
                            value: disabilityController
                                    .selectedDisabilityFilter.value.isEmpty
                                ? null
                                : disabilityController
                                    .selectedDisabilityFilter.value,
                            hint: Text('select_disability'.tr),
                            // Use translation key
                            isExpanded: true,
                            items: disabilityController.disabilities
                                .map((disability) => DropdownMenuItem<String>(
                                      value: disability["id"],
                                      child: Text(disability["name"]),
                                    ))
                                .toList(),
                            onChanged: (value) => disabilityController
                                .selectedDisabilityFilter.value = value ?? "",
                          )),
                    ),
                    SizedBox(width: 10),
                    // Type Filter Dropdown
                    Expanded(
                      child: Obx(
                        () => DropdownButton<String>(
                          value: disabilityController
                                  .selectedTypeFilter.value.isEmpty
                              ? null
                              : disabilityController.selectedTypeFilter.value,
                          hint: Text('select_type'.tr),
                          // Use translation key
                          isExpanded: true,
                          items: disabilityController.types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type["id"],
                              child: Text(type["name"]),
                            );
                          }).toList(),
                          onChanged: (value) => disabilityController
                              .selectedTypeFilter.value = value ?? "",
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Clear Filters Button
                    ElevatedButton(
                      onPressed: () {
                        disabilityController.searchQuery.value = '';
                        disabilityController.selectedDisabilityFilter.value =
                            '';
                        disabilityController.selectedTypeFilter.value = '';
                      },
                      child: Text('clear'.tr), // Use translation key
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Disability Count
                Obx(() => Text(
                    "${disabilityController.filteredDisabilities.length} ${'disabilities_found'.tr}")),
                // Use translation key
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
                child: Obx(() => ListView.builder(
                      itemCount:
                          disabilityController.filteredDisabilities.length,
                      itemBuilder: (context, index) {
                        var disability =
                            disabilityController.filteredDisabilities[index];
                        // return CustomContainer(
                        //   margin: EdgeInsets.symmetric(vertical: 6),
                        //   borderRadius: BorderRadius.circular(10),
                        //   conColor: Colors.white,
                        //   child: Row(
                        //     children: [
                        //       Icon(FontAwesomeIcons.wheelchair, color: Colors.green),
                        //       SizedBox(width: 10),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(disability["name"],
                        //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        //           Text("${disability["types"]} types"),
                        //         ],
                        //       ),
                        //       Spacer(),
                        //       Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           // Edit Button
                        //           IconButton(
                        //             icon: Icon(Icons.edit, color: Colors.black54),
                        //             onPressed: () {
                        //               print("Edit button pressed for disability: ${disability["name"]}"); // Debugging
                        //               _editDisabilityDialog(context, disability);
                        //             },
                        //           ),
                        //           // Delete Button
                        //           IconButton(
                        //             icon: Icon(Icons.delete, color: Colors.red),
                        //             onPressed: () =>
                        //                 disabilityController.deleteDisability(disability["id"]),
                        //           ),
                        //
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // );
                        return ExpansionTile(
                          leading: Icon(FontAwesomeIcons.wheelchair,
                              color: Colors.green),
                          title: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(disability["name"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text("${disability['types']} types"),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _editDisabilityDialog(
                                          context, disability);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Delete",
                                        middleText:
                                            "Are you sure you want to delete this disability?",
                                        textConfirm: "Yes",
                                        textCancel: "No",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () async {
                                          await disabilityController
                                              .deleteDisability(
                                                  disability["id"]);
                                          Get.back(); // Close dialog after delete
                                        },
                                        onCancel: () {
                                          Get.back(); // Optional: Close dialog on cancel
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: disabilityController
                                  .fetchTypesForDisability(disability["id"]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Failed to load types"),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("No types available"),
                                  );
                                } else {
                                  return Column(
                                    children: snapshot.data!.map((type) {
                                      return ListTile(
                                        leading: Icon(Icons.category,
                                            color: Colors.blue),
                                        title: Text(type["name"]),
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                          ],
                          // child: CustomContainer(
                          //   margin: EdgeInsets.symmetric(vertical: 6),
                          //   borderRadius: BorderRadius.circular(10),
                          //   conColor: Colors.white,
                          //   child: Row(
                          //     children: [
                          //       Icon(FontAwesomeIcons.wheelchair, color: Colors.green),
                          //       SizedBox(width: 10),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(disability["name"],
                          //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          //           Text("${disability["types"]} types"),
                          //         ],
                          //       ),
                          //       Spacer(),
                          //       Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           // Edit Button
                          //           IconButton(
                          //             icon: Icon(Icons.edit, color: Colors.black54),
                          //             onPressed: () {
                          //               print("Edit button pressed for disability: ${disability["name"]}"); // Debugging
                          //               _editDisabilityDialog(context, disability);
                          //             },
                          //           ),
                          //           // Delete Button
                          //           IconButton(
                          //             icon: Icon(Icons.delete, color: Colors.red),
                          //             onPressed: () =>
                          //                 disabilityController.deleteDisability(disability["id"]),
                          //           ),
                          //
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // )
                        );
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editDisabilityDialog(
      BuildContext context, Map<String, dynamic> disability) {
    print(
        "Edit dialog opened for disability: ${disability["name"]}"); // Debugging
    TextEditingController nameController =
        TextEditingController(text: disability["name"]);
    TextEditingController typeController = TextEditingController(
        text: disability["typeId"] ?? ""); // Controller for manual type input

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Disability"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Disability Name",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter disability name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 12),
                Text("Enter Type",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    hintText: "Enter type",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
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
                if (nameController.text.isNotEmpty &&
                    typeController.text.isNotEmpty) {
                  print(
                      "Updating disability with name: ${nameController.text} and type: ${typeController.text}"); // Debugging
                  await disabilityController.updateDisability(
                    disability["id"],
                    nameController.text.trim(),
                  );
                  Navigator.pop(context);
                  Get.snackbar(
                      "Disability", "Disability is updated Successfully");
                } else {
                  Get.snackbar("Validation", "Name or type is empty");
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
