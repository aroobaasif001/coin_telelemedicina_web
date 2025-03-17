import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:coin_telelemedicina_web/model/interpreter_model.dart';
import 'package:universal_html/html.dart' as html;

import '../../../utils/AppTheme.dart';

class EditInterpreterScreen extends StatefulWidget {
  final InterpreterModel interpreter;

  EditInterpreterScreen({required this.interpreter});

  @override
  _EditInterpreterScreenState createState() => _EditInterpreterScreenState();
}

class _EditInterpreterScreenState extends State<EditInterpreterScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  String _imageUrl = '';
  bool isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _biographyController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _healthCenterController;
  late TextEditingController _ratingController;
  late TextEditingController _totalRatingsController;

  bool _isVerified = false;

  final List<String> availableLanguages = ['English', 'French', 'Spanish', 'Sign Language'];
  List<String> selectedLanguages = [];

  final List<String> availableInterpreterTypes = ['Medical', 'Legal', 'Business', 'Community'];
  List<String> selectedInterpreterTypes = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.interpreter.fullName);
    _biographyController = TextEditingController(text: widget.interpreter.biography);
    _educationController = TextEditingController(text: widget.interpreter.education);
    _experienceController = TextEditingController(text: widget.interpreter.experience.toString());
    _healthCenterController = TextEditingController(text: widget.interpreter.healthCenterId);
    _ratingController = TextEditingController(text: widget.interpreter.rating.toString());
    _totalRatingsController = TextEditingController(text: widget.interpreter.totalRatings.toString());
    _isVerified = widget.interpreter.isVerified;
    selectedLanguages = widget.interpreter.languages;
    selectedInterpreterTypes = widget.interpreter.interpreterTypes;
    _imageUrl = widget.interpreter.photoUrl;
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
    Reference ref = FirebaseStorage.instance.ref().child('interpreterProfiles/$fileName');
    UploadTask uploadTask = ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    await uploadTask;
    return await ref.getDownloadURL();
  }

  Future<void> _updateInterpreter() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (_webImage != null) {
          _imageUrl = await _uploadImage(_webImage!);
        }

        await FirebaseFirestore.instance.collection('interpreterProfiles').doc(widget.interpreter.docId).update({
          'fullName': _nameController.text,
          'biography': _biographyController.text,
          'education': _educationController.text,
          'experience': int.parse(_experienceController.text),
          'healthCenterId': _healthCenterController.text,
          'languages': selectedLanguages,
          'interpreterTypes': selectedInterpreterTypes,
          'rating': double.parse(_ratingController.text),
          'totalRatings': int.parse(_totalRatingsController.text),
          'photoUrl': _imageUrl,
          'isVerified': _isVerified,
          'updatedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Interpreter details updated successfully!')),
        );

        Get.back();
      } catch (e) {
        print("Error updating interpreter: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update interpreter details')),
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
        title: Text('Edit Interpreter',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),

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
                      : (_imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : AssetImage('assets/img.png')) as ImageProvider,
                  child: _webImage == null && _imageUrl.isEmpty
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),

              _buildTextField(_nameController, 'Full Name', Icons.person),
              _buildTextField(_biographyController, 'Biography', Icons.info, maxLines: 3),
              _buildTextField(_educationController, 'Education', Icons.school),
              _buildTextField(_experienceController, 'Experience (years)', Icons.timer, isNumeric: true),
              _buildTextField(_healthCenterController, 'Health Center ID', Icons.local_hospital),
              _buildTextField(_ratingController, 'Rating', Icons.star, isNumeric: true),
              _buildTextField(_totalRatingsController, 'Total Ratings', Icons.rate_review, isNumeric: true),

              // Language Selection
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Languages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

              // Interpreter Type Selection
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Interpreter Types', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Wrap(
                spacing: 10,
                children: availableInterpreterTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: selectedInterpreterTypes.contains(type),
                    selectedColor: Colors.blue,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedInterpreterTypes.add(type);
                        } else {
                          selectedInterpreterTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // Is Verified Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isVerified,
                    onChanged: (bool? value) {
                      setState(() {
                        _isVerified = value ?? false;
                      });
                    },
                  ),
                  Text("Verified Interpreter"),
                ],
              ),
              SizedBox(height: 24),

              isLoading
                  ? CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton.icon(
                      onPressed: _updateInterpreter,
                      icon: Icon(Icons.save),
                      label: Text('Save Changes'),
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
      ),
    );
  }
}
