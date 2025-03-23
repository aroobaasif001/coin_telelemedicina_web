
import 'dart:io';
import 'dart:typed_data';

import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  final TextEditingController _iconController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();
  Uint8List? _imageFile; // Web compatible
  String? _imageUrl;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes(); 
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('service_icons/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putData(_imageFile!);
    _imageUrl = await storageRef.getDownloadURL();
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
        if (_imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload an image')));
        return;
      }
      final serviceData = {
        
        'id': _idController.text,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'duration': int.parse(_durationController.text),
        'icon': _imageUrl,
        'price': int.parse(_priceController.text),
        'requiresInterpreter': controller.requiresInterpreter.value,
        'supportedInterpreterTypes': controller.supportedInterpreterTypes,
        'isActive': true,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      await controller.addService(serviceData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text('Add Service',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_idController, 'ID', Icons.perm_identity),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Name', Icons.title),
              const SizedBox(height: 16),
              _buildTextField(_descriptionController, 'Description', Icons.description, maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_durationController, 'Duration (Minutes)', Icons.timer, isNumeric: true),
              const SizedBox(height: 16),
             InkWell(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text('Tap to select image')),
                      )
                    : Image.memory(_imageFile!, height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'Price', Icons.attach_money, isNumeric: true),
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
                      child: Text('Submit'),
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
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }
}
