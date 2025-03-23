import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart'; // Import GetX
import '../../../utils/AppTheme.dart';

class EditDoctorScreen extends StatefulWidget {
  final ProviderModel doctor;

  EditDoctorScreen({required this.doctor});

  @override
  _EditDoctorScreenState createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? _webImage;
  String _imageUrl = '';
  bool isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _biographyController;
  late TextEditingController _educationController;
  late TextEditingController _ratingController;
  late TextEditingController _reviewCountController;
  late TextEditingController _healthCenterController;
  bool _isVerified = false;

  final List<String> availableLanguages = [
    'kreyol'.tr, 'french'.tr, 'english'.tr, 'spanish'.tr, 'sign_language'.tr, 'portuguese'.tr
  ];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.fullName);
    _emailController = TextEditingController(text: widget.doctor.email);
    _specialtyController = TextEditingController(text: widget.doctor.specialty);
    _experienceController = TextEditingController(text: widget.doctor.experience.toString());
    _biographyController = TextEditingController(text: widget.doctor.biography);
    _educationController = TextEditingController(text: widget.doctor.education);
    _ratingController = TextEditingController(text: widget.doctor.rating.toString());
    _reviewCountController = TextEditingController(text: widget.doctor.reviewCount.toString());
    _healthCenterController = TextEditingController(text: widget.doctor.healthCenterId);
    _isVerified = widget.doctor.isVerified;
    selectedLanguages = widget.doctor.languages;
    _imageUrl = widget.doctor.photoUrl;
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
    Reference ref = FirebaseStorage.instance.ref().child('doctorProfiles/$fileName');
    UploadTask uploadTask = ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    await uploadTask;
    return await ref.getDownloadURL();
  }

  Future<void> _updateDoctor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (_webImage != null) {
          _imageUrl = await _uploadImage(_webImage!);
        }

        await FirebaseFirestore.instance.collection('providers').doc(widget.doctor.docId).update({
          'fullName': _nameController.text,
          'email': _emailController.text,
          'specialty': _specialtyController.text,
          'experience': int.parse(_experienceController.text),
          'biography': _biographyController.text,
          'education': _educationController.text,
          'languages': selectedLanguages,
          'rating': double.parse(_ratingController.text),
          'reviewCount': int.parse(_reviewCountController.text),
          'healthCenterId': _healthCenterController.text,
          'photoUrl': _imageUrl,
          'isVerified': _isVerified,
          'updatedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('doctor_details_updated'.tr)),
        );

        Navigator.pop(context);
      } catch (e) {
        print("Error updating doctor: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_update_doctor'.tr)),
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
        title: Text('edit_doctor_details'.tr, style: TextStyle(color: Colors.white)),
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
                      : (_imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : AssetImage('assets/default_avatar.png')) as ImageProvider,
                  child: _webImage == null && _imageUrl.isEmpty
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),

              _buildTextField(_nameController, 'full_name'.tr, Icons.person),
              _buildTextField(_emailController, 'email'.tr, Icons.email),
              _buildTextField(_specialtyController, 'specialty'.tr, Icons.medical_services),
              _buildTextField(_experienceController, 'experience'.tr, Icons.timer, isNumeric: true),
              _buildTextField(_biographyController, 'biography'.tr, Icons.description_outlined, maxLines: 3),
              _buildTextField(_educationController, 'education'.tr, Icons.school),
              _buildTextField(_ratingController, 'rating'.tr, Icons.star, isNumeric: true),
              _buildTextField(_reviewCountController, 'review_count'.tr, Icons.reviews, isNumeric: true),
              _buildTextField(_healthCenterController, 'health_center_id'.tr, Icons.business),

              // Language Selection
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('languages'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Wrap(
                spacing: 10,
                children: availableLanguages.map((language) {
                  return ChoiceChip(
                    label: Text(language),
                    selected: selectedLanguages.contains(language),
                    selectedColor: Colors.green,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedLanguages.add(language);
                        } else {
                          selectedLanguages.remove(language);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // Is Verified Checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isVerified,
                    onChanged: (bool? value) {
                      setState(() {
                        _isVerified = value ?? false;
                      });
                    },
                  ),
                  Text("verified_doctor".tr),
                ],
              ),
              SizedBox(height: 24),

              // Save Button
              isLoading
                  ? CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton.icon(
                onPressed: _updateDoctor,
                icon: Icon(Icons.save),
                label: Text('save_changes'.tr),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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