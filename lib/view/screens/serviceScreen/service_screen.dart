import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      final serviceData = {
        'id': _idController.text.trim(),
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'duration': int.tryParse(_durationController.text) ?? 0,
        'price': int.tryParse(_priceController.text) ?? 0,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("services")
          .doc(_idController.text.trim())
          .set(serviceData, SetOptions(merge: true));

      Get.snackbar(
        "Success",
        "Service added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form after successful submission
      _formKey.currentState?.reset();
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add service: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('add_service'.tr, style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
      ),
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
              _buildTextField(
                _descriptionController,
                'description'.tr,
                Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _durationController,
                'duration'.tr,
                Icons.timer,
                isNumeric: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'please_enter_duration'.tr;
                  if (int.tryParse(value) == null)
                    return 'enter_valid_number'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _priceController,
                'price'.tr,
                Icons.attach_money,
                isNumeric: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'please_enter_price'.tr;
                  if (int.tryParse(value) == null)
                    return 'enter_valid_number'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: _isLoading.value ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: _isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('submit'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool isNumeric = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
      validator: validator ??
          (value) => value!.isEmpty ? 'please_enter'.tr + ' $label' : null,
    );
  }
}

///

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controller/service_controller.dart';
//
// class ServiceScreen extends StatefulWidget {
//   @override
//   State<ServiceScreen> createState() => _ServiceScreenState();
// }
//
// class _ServiceScreenState extends State<ServiceScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       return;
//     }
//
//     final serviceData = {
//       'id': _idController.text,
//       'name': _nameController.text,
//       'description': _descriptionController.text,
//       'duration': int.parse(_durationController.text),
//       'price': int.parse(_priceController.text),
//       'isActive': true,
//       'createdAt': DateTime.now(),
//       'updatedAt': DateTime.now(),
//     };
//
//     await FirebaseFirestore.instance
//         .collection("services")
//         .doc(_idController.text)
//         .set(serviceData);
//     Get.snackbar("Services Updates", "Service is added Successfully");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: Text('add_service'.tr, style: TextStyle(color: Colors.white)),
//           backgroundColor: AppTheme.primaryColor),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildTextField(_idController, 'id'.tr, Icons.perm_identity),
//               const SizedBox(height: 16),
//               _buildTextField(_nameController, 'name'.tr, Icons.title),
//               const SizedBox(height: 16),
//               _buildTextField(
//                   _descriptionController, 'description'.tr, Icons.description,
//                   maxLines: 3),
//               const SizedBox(height: 16),
//               _buildTextField(_durationController, 'duration'.tr, Icons.timer,
//                   isNumeric: true),
//               const SizedBox(height: 16),
//               _buildTextField(_priceController, 'price'.tr, Icons.attach_money,
//                   isNumeric: true),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('submit'.tr),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller, String label, IconData icon,
//       {int maxLines = 1, bool isNumeric = false}) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       maxLines: maxLines,
//       validator: (value) =>
//           value!.isEmpty ? 'please_enter'.tr + ' $label' : null,
//     );
//   }
// }
