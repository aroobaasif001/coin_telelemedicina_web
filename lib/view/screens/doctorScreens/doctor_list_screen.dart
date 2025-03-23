import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/patient/patient_view_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/AppTheme.dart';
import 'controller/doctor_controller.dart';
import 'doctor_detail_screen.dart';
import 'doctor_edit_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final DoctorController doctorController = Get.put(DoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'Doctors List'),
          // Doctor List
          Expanded(
            child: CustomContainer(
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              conColor: Colors.white,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                    ),
                    child: TextField(
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Search by name, email or disability...',
                        prefixIcon: Icon(Icons.search, size: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(
                      () {
                        if (doctorController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                    
                        if (doctorController.doctors.isEmpty) {
                          return Center(child: Text('No doctors found.'));
                        }
                    
                        return Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                  ),    
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Doctor",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Specialty",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Experience",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Rating",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Actions",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: doctorController.doctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = doctorController.doctors[index];
                                  return Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                           border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.grey[300],
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      doctor.photoUrl,
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        print("Error loading doctor image: ${doctor.photoUrl}");
                                                        return Image.asset('assets/img.png',
                                                            width: 60, height: 60, fit: BoxFit.cover);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    doctor.fullName,
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(doctor.specialty,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${doctor.experience} yrs'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${doctor.rating} ★'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_red_eye,
                                                      color: Colors.blue, size: 13),
                                                  onPressed: () {                             
                                                     Get.to(() => MainLayout(child: DoctorDetailScreen(doctor: doctor)));
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit, color: Colors.red, size: 13),
                                                  onPressed: () {
                                                     Get.to(() => MainLayout(child: EditDoctorScreen(doctor: doctor)));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                                                     Get.to(() => MainLayout(child: DoctorScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
