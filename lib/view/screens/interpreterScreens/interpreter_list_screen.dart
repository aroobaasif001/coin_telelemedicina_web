import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_screen.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              conColor: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: Obx(() {
                if (interpreterController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
            
                if (interpreterController.interpreters.isEmpty) {
                  return Center(child: Text('No interpreters found.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: interpreterController.interpreters.length,
                  itemBuilder: (context, index) {
                    final interpreter = interpreterController.interpreters[index];
            
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: interpreter.photoUrl.isNotEmpty
                              ? NetworkImage(interpreter.photoUrl)
                              : AssetImage('assets/img.png') as ImageProvider,
                        ),
                        title: Text(interpreter.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Languages: ${interpreter.languages.join(', ')}\nExperience: ${interpreter.experience} years'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Get.to(() => InterpreterDetailScreen(interpreter: interpreter));
                            } else if (value == 'edit') {
                              Get.to(() => EditInterpreterScreen(interpreter: interpreter));
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
          Get.to(() => InterpreterScreen());
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
