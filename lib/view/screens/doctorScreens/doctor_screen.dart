import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/components/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:math';

import '../../../utils/AppTheme.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  String _imageUrl = '';
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _healthCenterIdController =
      TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  final List<String> availableLanguages = [
    'Kreyol',
    'French',
    'English',
    'Spanish',
    'Sign Language',
    'Portuguese'
  ];
  final List<String> selectedLanguages = [];

  String _generatePassword(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> _pickImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
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
    Reference ref =
        FirebaseStorage.instance.ref().child('doctorProfiles/$fileName');
    UploadTask uploadTask =
        ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    await uploadTask;
    return await ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String generatedPassword = _passwordController.text.isEmpty
            ? _generatePassword(8)
            : _passwordController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: generatedPassword,
        );
        String docId = userCredential.user!.uid;
        if (_webImage != null) {
          _imageUrl = await _uploadImage(_webImage!);
        }

        ProviderModel doctor = ProviderModel(
          docId: docId,
          email: _emailController.text,
          fullName: _fullNameController.text,
          biography: _biographyController.text,
          education: _educationController.text,
          experience: int.parse(_experienceController.text),
          healthCenterId: _healthCenterIdController.text,
          isVerified: true,
          languages: selectedLanguages,
          photoUrl: _imageUrl,
          rating: 4.5,
          reviewCount: 100,
          specialty: _specialtyController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('providers')
            .doc(userCredential.user!.uid)
            .set({
          'docId': docId,
          ...doctor.toMap(),
          'email': _emailController.text,
          'generatedPassword': generatedPassword,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Doctor profile saved successfully! Password: $generatedPassword')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
        title: Text('Add Doctor',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      _webImage != null ? MemoryImage(_webImage!) : null,
                  child: _webImage == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_emailController, 'Email', Icons.email_outlined),
              SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password (Optional)',
                  Icons.lock_outline,
                  isObscure: true),
              SizedBox(height: 16),
              _buildTextField(
                  _fullNameController, 'Full Name', Icons.person_outline),
              SizedBox(height: 16),
              _buildTextField(
                  _biographyController, 'Biography', Icons.description_outlined,
                  maxLines: 3),
              SizedBox(height: 16),
              _buildTextField(
                  _educationController, 'Education', Icons.school_outlined),
              SizedBox(height: 16),
              _buildTextField(_experienceController, 'Experience (Years)',
                  Icons.work_outline,
                  isNumeric: true),
              SizedBox(height: 16),
              _buildTextField(_healthCenterIdController, 'Health Center ID',
                  Icons.local_hospital_outlined),
              SizedBox(height: 16),
              _buildTextField(_specialtyController, 'Specialty',
                  Icons.medical_services_outlined),
              SizedBox(height: 24),
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
              SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Submit',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, bool isNumeric = false, bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
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
