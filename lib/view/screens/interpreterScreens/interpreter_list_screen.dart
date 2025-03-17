import 'package:coin_telelemedicina_web/view/screens/interpreterScreens/interpreter_screen.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Interpreters List', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (interpreterController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (interpreterController.interpreters.isEmpty) {
          return Center(child: Text('No interpreters found.'));
        }

        return ListView.builder(
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
