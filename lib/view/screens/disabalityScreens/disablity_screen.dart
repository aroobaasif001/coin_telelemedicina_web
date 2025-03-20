import 'package:coin_telelemedicina_web/view/screens/disabalityScreens/addDisabailityScreen/add_disabaility_screen.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Provinces & Municipalities",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: (){
                    Get.to(()=>AddDisabilityScreen());
                  },
                  child: Container(
                    
                    decoration: BoxDecoration(
                      color:AppTheme.primaryColor  ,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.add,color: Colors.white,),
                          SizedBox(width: 10,),
                          CustomText(text: 'Add Disability',color: Colors.white,)
                         
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
                        hint: Text("Select Disability"),
                        isExpanded: true,
                        items: disabilityController.disabilities
                            .map((disability) => DropdownMenuItem<String>(
                                  value: disability["id"],
                                  child: Text(disability["name"]),
                                ))
                            .toList(),
                        onChanged: (value) => disabilityController.selectedDisabilityFilter.value = value ?? "",
                      )),
                ),
                SizedBox(width: 10),

                // Type Filter Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: disabilityController.selectedTypeFilter.value.isEmpty
                        ? null
                        : disabilityController.selectedTypeFilter.value,
                    hint: Text("Select Type"),
                    isExpanded: true,
                    items: [], // You can fetch types here
                    onChanged: (value) => disabilityController.selectedTypeFilter.value = value ?? "",
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
                  child: Text("Clear"),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Disability Count
            Obx(() => Text("${disabilityController.filteredDisabilities.length} disabilities found")),

            // Disability List
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: disabilityController.filteredDisabilities.length,
                    itemBuilder: (context, index) {
                      var disability = disabilityController.filteredDisabilities[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.wheelchair, color: Colors.green),
                          title: Text(disability["name"],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text("${disability["types"]} types"),
                          trailing: Row(
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
                                onPressed: () => disabilityController.deleteDisability(disability["id"]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
