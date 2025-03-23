import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/AppTheme.dart';
import 'controller/interpreter_controller.dart';
import 'interpreter_detail_screen.dart';
import 'interpreter_edit_screen.dart';

class InterpreterListScreen extends StatelessWidget {
  final InterpreterController interpreterController = Get.put(InterpreterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'Interpreters List'),
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
                        if (interpreterController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (interpreterController.interpreters.isEmpty) {
                          return const Center(child: Text('No doctors found.'));
                        }

                        return Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(3),
                                4: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey.shade200),
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Doctor", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Experience", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Rating", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Registration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Actions", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: interpreterController.interpreters.length,
                                itemBuilder: (context, index) {
                                  final interpreter = interpreterController.interpreters[index];

                                  // Safely convert updatedAt to Date
                                  String updatedDate = '';
                                  try {
                                    if (interpreter.updatedAt is Timestamp) {
                                      updatedDate = DateFormat('yyyy-MM-dd')
                                          .format((interpreter.updatedAt as Timestamp).toDate().toLocal());
                                    } else if (interpreter.updatedAt != null) {
                                      updatedDate = DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(interpreter.updatedAt.toString()).toLocal());
                                    }
                                  } catch (e) {
                                    updatedDate = 'N/A';
                                  }

                                  return Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(3),
                                      4: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(
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
                                                      interpreter.photoUrl,
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        print("Error loading image: ${interpreter.photoUrl}");
                                                        return Image.asset('assets/img.png',
                                                            width: 60, height: 60, fit: BoxFit.cover);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    interpreter.fullName,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${interpreter.experience} yrs'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${interpreter.rating} ★'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.calendar_today, size: 13),
                                                const SizedBox(width: 4),
                                                Text(updatedDate, style: const TextStyle(fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 18),
                                                  onPressed: () {
                                                     Get.to(() => MainLayout(child: InterpreterDetailScreen(interpreter: interpreter)));



                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit, color: Colors.red, size: 18),
                                                  onPressed: () {
                                                             Get.to(() => MainLayout(child:EditInterpreterScreen(interpreter: interpreter)));

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
          // Expanded(
          //   child: CustomContainer(
          //     conColor: Colors.white,
          //     margin: EdgeInsets.all(10),
          //     borderRadius: BorderRadius.circular(10),
          //     child: Obx(() {
          //       if (interpreterController.isLoading.value) {
          //         return Center(child: CircularProgressIndicator());
          //       }
          //
          //       if (interpreterController.interpreters.isEmpty) {
          //         return Center(child: Text('No interpreters found.'));
          //       }
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: interpreterController.interpreters.length,
          //         itemBuilder: (context, index) {
          //           final interpreter = interpreterController.interpreters[index];
          //
          //           return Card(
          //             margin: EdgeInsets.all(8.0),
          //             child: ListTile(
          //               leading: CircleAvatar(
          //                 radius: 30,
          //                 backgroundImage: interpreter.photoUrl.isNotEmpty
          //                     ? NetworkImage(interpreter.photoUrl)
          //                     : AssetImage('assets/img.png') as ImageProvider,
          //               ),
          //               title: Text(interpreter.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
          //               subtitle: Text(
          //                   'Languages: ${interpreter.languages.join(', ')}\nExperience: ${interpreter.experience} years'),
          //               trailing: PopupMenuButton<String>(
          //                 onSelected: (value) {
          //                   if (value == 'view') {
          //                     Get.to(() => InterpreterDetailScreen(interpreter: interpreter));
          //                   } else if (value == 'edit') {
          //                     Get.to(() => EditInterpreterScreen(interpreter: interpreter));
          //                   }
          //                 },
          //                 itemBuilder: (context) => [
          //                   PopupMenuItem(value: 'view', child: Text('View Details')),
          //                   PopupMenuItem(value: 'edit', child: Text('Edit Details')),
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
                                                             Get.to(() => MainLayout(child:InterpreterScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
