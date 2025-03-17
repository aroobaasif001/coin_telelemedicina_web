// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:universal_html/html.dart' as html;
// import '../../../model/interpreter_model.dart';
// import '../../../utils/AppTheme.dart';

// class InterpreterScreen extends StatefulWidget {
//   const InterpreterScreen({super.key});

//   @override
//   State<InterpreterScreen> createState() => _InterpreterScreenState();
// }

// class _InterpreterScreenState extends State<InterpreterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   Uint8List? _webImage;
//   File? _mobileImage;
//   String _imageUrl = '';
//   bool isLoading = false;

//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _biographyController = TextEditingController();
//   final TextEditingController _educationController = TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//   final TextEditingController _healthCenterIdController = TextEditingController();

//   List<String> selectedLanguages = [];
//   List<String> selectedInterpreterTypes = [];

//   final List<String> availableLanguages = ['Spanish', 'Sign Language', 'English', 'French'];
//   final List<String> availableInterpreterTypes = ['sign-language', 'english', 'french'];

//   Future<void> _pickImage() async {
//     if (kIsWeb) {
//       final input = html.FileUploadInputElement()..accept = 'image/*';
//       input.click();

//       input.onChange.listen((event) {
//         final file = input.files?.first;
//         if (file != null) {
//           final reader = html.FileReader();
//           reader.readAsArrayBuffer(file);
//           reader.onLoadEnd.listen((e) {
//             setState(() {
//               _webImage = reader.result as Uint8List;
//             });
//           });
//         }
//       });
//     } else {
//       final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _mobileImage = File(pickedFile.path);
//         });
//       }
//     }
//   }

//   Future<String> _uploadImage() async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference ref = FirebaseStorage.instance.ref().child('interpreterProfiles/$fileName');

//     UploadTask uploadTask;
//     if (kIsWeb && _webImage != null) {
//       uploadTask = ref.putData(_webImage!, SettableMetadata(contentType: 'image/jpeg'));
//     } else if (_mobileImage != null) {
//       uploadTask = ref.putFile(_mobileImage!);
//     } else {
//       throw Exception('No image selected');
//     }

//     await uploadTask;
//     return await ref.getDownloadURL();
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_webImage == null && _mobileImage == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select an image.')),
//         );
//         return;
//       }

//       if (selectedInterpreterTypes.isEmpty || selectedLanguages.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select Interpreter Types and Languages.')),
//         );
//         return;
//       }

//       setState(() {
//         isLoading = true;
//       });

//       try {
//         _imageUrl = await _uploadImage();

//         InterpreterModel interpreter = InterpreterModel(
//           fullName: _fullNameController.text,
//           biography: _biographyController.text,
//           education: _educationController.text,
//           experience: int.tryParse(_experienceController.text) ?? 0,
//           healthCenterId: _healthCenterIdController.text,
//           interpreterTypes: selectedInterpreterTypes,
//           languages: selectedLanguages,
//           photoUrl: _imageUrl,
//           isVerified: true,
//           rating: 4.5,
//           totalRatings: 100,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(), docId: '',
//         );

//         await FirebaseFirestore.instance.collection('interpreterProfiles').add(interpreter.toMap());

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Interpreter profile saved successfully!')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         centerTitle: true,
//         title: Text('Add Interpreter Screen',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundImage: _webImage != null
//                       ? MemoryImage(_webImage!)
//                       : _mobileImage != null
//                           ? FileImage(_mobileImage!) as ImageProvider
//                           : null,
//                   child: _webImage == null && _mobileImage == null
//                       ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
//                       : null,
//                   backgroundColor: Colors.grey[200],
//                 ),
//               ),
              
//               const SizedBox(height: 20),

//               _buildTextField(_fullNameController, 'Full Name', Icons.person_outline),
//               const SizedBox(height: 16),

//               _buildTextField(_biographyController, 'Biography', Icons.description_outlined, maxLines: 3),
//               const SizedBox(height: 16),

//               _buildTextField(_educationController, 'Education', Icons.school_outlined),
//               const SizedBox(height: 16),

//               _buildTextField(_experienceController, 'Experience (Years)', Icons.work_outline, isNumeric: true),
//               const SizedBox(height: 16),

//               _buildTextField(_healthCenterIdController, 'Health Center ID', Icons.local_hospital_outlined),
//               const SizedBox(height: 24),

//               _buildChips('Interpreter Types', availableInterpreterTypes, selectedInterpreterTypes),
//               const SizedBox(height: 16),

//               _buildChips('Languages', availableLanguages, selectedLanguages),
//               const SizedBox(height: 24),

//               isLoading
//                   ? const CircularProgressIndicator(color: Colors.green)
//                   : ElevatedButton(
//                       onPressed: _submitForm,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text('Submit'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChips(String title, List<String> options, List<String> selectedOptions) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         Wrap(
//           spacing: 8,
//           children: options.map((item) {
//             return FilterChip(
//               label: Text(item),
//               selected: selectedOptions.contains(item),
//               onSelected: (bool selected) {
//                 setState(() {
//                   if (selected) {
//                     selectedOptions.add(item);
//                   } else {
//                     selectedOptions.remove(item);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, IconData icon,
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
//       validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import '../../../model/interpreter_model.dart';
import '../../../utils/AppTheme.dart';

class InterpreterScreen extends StatefulWidget {
  const InterpreterScreen({super.key});

  @override
  State<InterpreterScreen> createState() => _InterpreterScreenState();
}

class _InterpreterScreenState extends State<InterpreterScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  File? _mobileImage;
  String _imageUrl = '';
  bool isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _healthCenterIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<String> selectedLanguages = [];
  List<String> selectedInterpreterTypes = [];

  final List<String> availableLanguages = ['Spanish', 'Sign Language', 'English', 'French'];
  final List<String> availableInterpreterTypes = ['sign-language', 'english', 'french'];

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final input = html.FileUploadInputElement()..accept = 'image/*';
      input.click();

      input.onChange.listen((event) {
        final file = input.files?.first;
        if (file != null) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((e) {
            setState(() {
              _webImage = reader.result as Uint8List;
            });
          });
        }
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _mobileImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<String> _uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('interpreterProfiles/$fileName');

    UploadTask uploadTask;
    if (kIsWeb && _webImage != null) {
      uploadTask = ref.putData(_webImage!, SettableMetadata(contentType: 'image/jpeg'));
    } else if (_mobileImage != null) {
      uploadTask = ref.putFile(_mobileImage!);
    } else {
      throw Exception('No image selected');
    }

    await uploadTask;
    return await ref.getDownloadURL();
  }


  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (_webImage == null && _mobileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    if (selectedInterpreterTypes.isEmpty || selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Interpreter Types and Languages.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;

      // Upload profile image
      _imageUrl = await _uploadImage();

      // ✅ Extract numeric value from experience
      String experienceInput = _experienceController.text.trim();
      String numericExperience = experienceInput.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric chars
      int experienceYears = int.tryParse(numericExperience) ?? 0;

      // Create interpreter model
      InterpreterModel interpreter = InterpreterModel(
        fullName: _fullNameController.text,
        biography: _biographyController.text,
        education: _educationController.text,
        experience: experienceYears, // Corrected experience value
        healthCenterId: _healthCenterIdController.text,
        interpreterTypes: selectedInterpreterTypes,
        languages: selectedLanguages,
        photoUrl: _imageUrl,
        isVerified: true,
        rating: 4.5,
        totalRatings: 100,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        docId: userId,
      );

      await FirebaseFirestore.instance.collection('interpreterProfiles').doc(userId).set(interpreter.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interpreter profile saved successfully!')),
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


  // Future<void> _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     if (_webImage == null && _mobileImage == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please select an image.')),
  //       );
  //       return;
  //     }

  //     if (selectedInterpreterTypes.isEmpty || selectedLanguages.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please select Interpreter Types and Languages.')),
  //       );
  //       return;
  //     }

  //     setState(() {
  //       isLoading = true;
  //     });

  //     try {
  //       // Register the user with Firebase Authentication
  //       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       String userId = userCredential.user!.uid;

  //       // Upload profile image
  //       _imageUrl = await _uploadImage();

  //       // Create interpreter model
  //       InterpreterModel interpreter = InterpreterModel(
  //         fullName: _fullNameController.text,
  //         biography: _biographyController.text,
  //         education: _educationController.text,
  //         experience: int.tryParse(_experienceController.text) ?? 0,
  //         healthCenterId: _healthCenterIdController.text,
  //         interpreterTypes: selectedInterpreterTypes,
  //         languages: selectedLanguages,
  //         photoUrl: _imageUrl,
  //         isVerified: true,
  //         rating: 4.5,
  //         totalRatings: 100,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //         docId: userId, // Store Firebase UID
  //       );

  //       // Store user data in Firestore
  //       await FirebaseFirestore.instance.collection('interpreterProfiles').doc(userId).set(interpreter.toMap());

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Interpreter profile saved successfully!')),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     } finally {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Interpreter Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                      : _mobileImage != null
                          ? FileImage(_mobileImage!) as ImageProvider
                          : null,
                  child: _webImage == null && _mobileImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(_fullNameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 16),

              _buildTextField(_emailController, 'Email', Icons.email_outlined),
              const SizedBox(height: 16),

              _buildTextField(_passwordController, 'Password', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),

              _buildTextField(_biographyController, 'Biography', Icons.description_outlined, maxLines: 3),
              const SizedBox(height: 16),

              _buildTextField(_educationController, 'Education', Icons.school_outlined),
              const SizedBox(height: 16),

              _buildTextField(_experienceController, 'Experience (Years)', Icons.work_outline,isNumeric: true ),
              const SizedBox(height: 16),

              _buildTextField(_healthCenterIdController, 'Health Center ID', Icons.local_hospital_outlined),
              const SizedBox(height: 24),

              _buildChips('Interpreter Types', availableInterpreterTypes, selectedInterpreterTypes),
              const SizedBox(height: 16),

              _buildChips('Languages', availableLanguages, selectedLanguages),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, bool isPassword = false,bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
  
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }
    Widget _buildChips(String title, List<String> options, List<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Wrap(
          spacing: 8,
          children: options.map((item) {
            return FilterChip(
              label: Text(item),
              selected: selectedOptions.contains(item),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(item);
                  } else {
                    selectedOptions.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

}
