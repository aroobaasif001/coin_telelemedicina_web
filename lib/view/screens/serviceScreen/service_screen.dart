import 'dart:typed_data';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'controller/service_controller.dart';

class ServiceScreen extends StatefulWidget {
  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ServiceController());

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
        return;
      }

      final serviceData = {
        'id': _idController.text,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'duration': int.parse(_durationController.text),
        'price': int.parse(_priceController.text),
        'isActive': true,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      await controller.addService(serviceData);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('add_service'.tr, style: TextStyle(color: Colors.white)),
          backgroundColor: AppTheme.primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_idController, 'id'.tr, Icons.perm_identity),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'name'.tr, Icons.title),
              const SizedBox(height: 16),
              _buildTextField(_descriptionController, 'description'.tr, Icons.description, maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_durationController, 'duration'.tr, Icons.timer, isNumeric: true),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'price'.tr, Icons.attach_money, isNumeric: true),
              const SizedBox(height: 16),
              // Obx(() => SwitchListTile(
              //       title: Text('Requires Interpreter'),
              //       value: controller.requiresInterpreter.value,
              //       onChanged: (value) => controller.requiresInterpreter(value),
              //     )),
              // const SizedBox(height: 16),
              // Obx(() => Wrap(
              //       spacing: 8,
              //       children: ['Type1', 'Type2', 'Type3'].map((type) {
              //         return FilterChip(
              //           label: Text(type),
              //           selected: controller.supportedInterpreterTypes.contains(type),
              //           onSelected: (bool selected) {
              //             if (selected) {
              //               controller.supportedInterpreterTypes.add(type);
              //             } else {
              //               controller.supportedInterpreterTypes.remove(type);
              //             }
              //           },
              //         );
              //       }).toList(),
              //     )),
              const SizedBox(height: 24),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitForm,
                child: Text('submit'.tr),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? 'please_enter'.tr + ' $label' : null,
    );
  }
}
