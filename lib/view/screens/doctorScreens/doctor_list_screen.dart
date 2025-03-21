import 'package:coin_telelemedicina_web/view/screens/doctorScreens/doctor_screen.dart';
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
          Expanded(
            child: CustomContainer(
              conColor: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Obx(() {
                if (doctorController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (doctorController.doctors.isEmpty) {
                  return Center(child: Text('No doctors found.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: doctorController.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctorController.doctors[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   radius: 50,
                        //   backgroundColor: Colors.grey[300],
                        //   backgroundImage: doctor.photoUrl.isNotEmpty
                        //       ? NetworkImage(doctor.photoUrl)
                        //       : AssetImage('assets/img.png') as ImageProvider,
                        //   onBackgroundImageError: (_, __) {
                        //     print("Error loading doctor image: ${doctor.photoUrl}");
                        //   },
                        // ),
                        leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: Image.network(
              doctor.photoUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading doctor image: ${doctor.photoUrl}");
                return Image.asset('assets/img.png', width: 100, height: 100, fit: BoxFit.cover);
              },
                  ),
                ),
              ),

                        title: Text(doctor.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Specialty: ${doctor.specialty}\nExperience: ${doctor.experience} years'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Get.to(() => DoctorDetailScreen(doctor: doctor));
                            } else if (value == 'edit') {
                              Get.to(() => EditDoctorScreen(doctor: doctor));
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'view', child: Text('View Details')),
                            PopupMenuItem(value: 'edit', child: Text('Edit Details')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DoctorScreen());
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
