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
  final InterpreterController interpreterController =
      Get.put(InterpreterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'interpreters_list'.tr), // Use translation key
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
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                      ],
                    ),
                    child: TextField(
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'search_hint'.tr, // Use translation key
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (interpreterController.interpreters.isEmpty) {
                          return Center(
                              child: Text('no_interpreters_found'
                                  .tr)); // Use translation key
                        }

                        return Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(3),
                                3: FlexColumnWidth(2),

                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('interpreter'.tr,
                                          // Use translation key
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('experience'.tr,
                                          // Use translation key
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('registration'.tr,
                                          // Use translation key
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          'actions'.tr, // Use translation key
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    interpreterController.interpreters.length,
                                itemBuilder: (context, index) {
                                  final interpreter =
                                      interpreterController.interpreters[index];

                                  String updatedDate = '';
                                  try {
                                    if (interpreter.updatedAt is Timestamp) {
                                      updatedDate = DateFormat('yyyy-MM-dd')
                                          .format((interpreter.updatedAt
                                                  as Timestamp)
                                              .toDate()
                                              .toLocal());
                                    } else if (interpreter.updatedAt != null) {
                                      updatedDate = DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(interpreter
                                                  .updatedAt
                                                  .toString())
                                              .toLocal());
                                    }
                                  } catch (e) {
                                    updatedDate = 'N/A';
                                  }

                                  return Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(3),
                                      3: FlexColumnWidth(2),

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
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      interpreter.photoUrl,
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        print(
                                                            "Error loading image: ${interpreter.photoUrl}");
                                                        return Image.asset(
                                                            'assets/img.png',
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    interpreter.fullName,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${interpreter.experience} ${'years'.tr}'), // Use translation key
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.calendar_today,
                                                    size: 13),
                                                const SizedBox(width: 4),
                                                Text(updatedDate,
                                                    style: const TextStyle(
                                                        fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.blue,
                                                      size: 18),

                                                  onPressed: () {
                                                    Get.to(() => MainLayout(
                                                        child: InterpreterDetailScreen(
                                                            interpreter:
                                                                interpreter)));
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.red,
                                                      size: 18),
                                                  onPressed: () {
                                                    Get.to(() => MainLayout(
                                                        child: EditInterpreterScreen(
                                                            interpreter:
                                                                interpreter)));
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
          Get.to(() => MainLayout(child: InterpreterScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
