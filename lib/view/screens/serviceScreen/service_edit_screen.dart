import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:coin_telelemedicina_web/model/service_model.dart';
import 'package:universal_html/html.dart' as html;
import '../../../utils/AppTheme.dart';

class ServiceEditScreen extends StatefulWidget {
  final ServiceModel service;

  ServiceEditScreen({required this.service});

  @override
  _ServiceEditScreenState createState() => _ServiceEditScreenState();
}

class _ServiceEditScreenState extends State<ServiceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  String _imageUrl = '';
  bool isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  bool _requiresInterpreter = false;
  bool _isActive = true;
  List<String> _supportedInterpreterTypes = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service.name);
    _descriptionController = TextEditingController(text: widget.service.description);
    _durationController = TextEditingController(text: widget.service.duration.toString());
    _priceController = TextEditingController(text: widget.service.price.toString());
    _requiresInterpreter = widget.service.requiresInterpreter;
    _isActive = widget.service.isActive;
    _supportedInterpreterTypes = widget.service.supportedInterpreterTypes;
    _imageUrl = widget.service.icon;
  }

  Future<void> _pickImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(input.files!.first);
      reader.onLoadEnd.listen((event) {
        setState(() {
          _webImage = reader.result as Uint8List;
        });
      });
    });
  }

  Future<String> _uploadImage(Uint8List imageBytes) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('service_icons/$fileName');
    UploadTask uploadTask = ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    await uploadTask;
    return await ref.getDownloadURL();
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (_webImage != null) {
          _imageUrl = await _uploadImage(_webImage!);
        }

        await FirebaseFirestore.instance.collection('services').doc(widget.service.id).update({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'duration': int.parse(_durationController.text),
          'price': int.parse(_priceController.text),
          'icon': _imageUrl,
          'requiresInterpreter': _requiresInterpreter,
          'isActive': _isActive,
          'supportedInterpreterTypes': _supportedInterpreterTypes,
          'updatedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('service_updated_successfully'.tr)),
        );

        Get.back();
      } catch (e) {
        print("Error updating service: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_update_service'.tr)),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit_service'.tr, style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _webImage != null
                      ? MemoryImage(_webImage!)
                      : (_imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : AssetImage('assets/default_service.png')) as ImageProvider,
                  child: _webImage == null && _imageUrl.isEmpty
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),

              _buildTextField(_nameController, 'service_name'.tr, Icons.title),
              _buildTextField(_descriptionController, 'description'.tr, Icons.description, maxLines: 3),
              _buildTextField(_durationController, 'duration_mins'.tr, Icons.timer, isNumeric: true),
              _buildTextField(_priceController, 'price'.tr, Icons.attach_money, isNumeric: true),

              // Requires Interpreter Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('requires_interpreter'.tr, style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _requiresInterpreter,
                    onChanged: (bool value) {
                      setState(() {
                        _requiresInterpreter = value;
                      });
                    },
                  ),
                ],
              ),

              // Service Active Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('service_active'.tr, style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isActive,
                    onChanged: (bool value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
              ),

              // Supported Interpreter Types
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('supported_interpreter_types'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Wrap(
                spacing: 10,
                children: ['medical'.tr, 'legal'.tr, 'business'.tr, 'community'.tr].map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _supportedInterpreterTypes.contains(type),
                    selectedColor: Colors.blue,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _supportedInterpreterTypes.add(type);
                        } else {
                          _supportedInterpreterTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 24),

              isLoading
                  ? CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton.icon(
                onPressed: _updateService,
                icon: Icon(Icons.save),
                label: Text('save_changes'.tr),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? '${'please_enter'.tr} $label' : null,
      ),
    );
  }
}