import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/custom_textfield.dart';
import '../../../controller/auth_controller.dart';
import '../../../model/patient_model.dart';
import '../../../widget/CustomText.dart';
import 'controller/localization_controller.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final Map<String, dynamic>? patientData;
  final String? patientId;
  final bool isEditMode;

  const PatientRegistrationScreen({
    Key? key,
    this.patientData,
    this.patientId,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final AuthController authController = Get.put(AuthController());
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? selectedDisability;
  List<String> disabilities = [];
  bool isUploading = false;
  bool isFetchingDisabilities = false;
  bool isRegistering = false;
  String? selectedProvince;
  String? selectedMunicipality;
  String? selectedSector;

  List<String> genders = ['Male', 'Female', 'Other'];
  String? selectedGender;

  List<dynamic> cedulaImages = [];
  List<dynamic> insuranceImages = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchDisabilities();
    if (widget.isEditMode && widget.patientData != null) {
      _prefillForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> pickImages(bool isCedula) async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..multiple = true;
      input.click();

      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          for (final file in files) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);
            reader.onLoadEnd.listen((event) {
              setState(() {
                if (isCedula) {
                  cedulaImages.add(reader.result as Uint8List);
                } else {
                  insuranceImages.add(reader.result as Uint8List);
                }
              });
            });
          }
        }
      });
    } else {
      final picker = ImagePicker();
      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          List<File> selectedFiles =
              pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();

          if (isCedula) {
            cedulaImages.addAll(selectedFiles);
          } else {
            insuranceImages.addAll(selectedFiles);
          }
        });
      }
    }
  }

  void removeImage(int index, bool isCedula) {
    setState(() {
      if (isCedula) {
        cedulaImages.removeAt(index);
      } else {
        insuranceImages.removeAt(index);
      }
    });
  }

  Future<String> uploadFile(dynamic file, String folderName) async {
    try {
      setState(() => isUploading = true);
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref =
          FirebaseStorage.instance.ref().child(folderName).child(fileName);

      if (kIsWeb && file is Uint8List) {
        UploadTask uploadTask =
            ref.putData(file, SettableMetadata(contentType: 'image/jpeg'));
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } else if (file is File) {
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }
      return "";
    } catch (e) {
      print("File upload error: $e");
      return "";
    } finally {
      setState(() => isUploading = false);
    }
  }

  void _prefillForm() {
    final data = widget.patientData!;
    fullNameController.text = data['fullName'] ?? '';
    phoneNumberController.text = data['phoneNumber'] ?? '';
    dobController.text = data['dob'] ?? '';
    idController.text = data['id'] ?? '';
    addressController.text = data['address'] ?? '';
    emailController.text = data['email'] ?? '';
    selectedGender = data['gender'];
    selectedDisability = data['disability'];

    setState(() {
      selectedProvince = data['provincia'];
      selectedMunicipality = data['municipality'];
      selectedSector = data['sector'];
    });

    locationController.selectedProvince.value = data['provincia'] ?? '';
    locationController.selectedMunicipality.value = data['municipality'] ?? '';
    locationController.selectedSector.value = data['sector'] ?? '';

    if (data['provincia'] != null) {
      locationController.fetchMunicipalities(data['provincia']);
    }
    if (data['municipality'] != null) {
      locationController.fetchSectors(data['municipality']);
    }
  }

  Future<void> fetchDisabilities() async {
    try {
      setState(() => isFetchingDisabilities = true);
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('disabilities').get();
      setState(() {
        disabilities =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching disabilities: $e");
    } finally {
      setState(() => isFetchingDisabilities = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  widget.isEditMode == false
                      ? CustomTextField(
                          hintText: 'Email',
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  widget.isEditMode == false
                      ? CustomTextField(
                          hintText: 'Password',
                          controller: passwordController,
                          readOnly: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  widget.isEditMode == false
                      ? CustomTextField(
                          hintText: 'Confirm Password',
                          controller: confirmPasswordController,
                          readOnly: false,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        )
                      : SizedBox(),
                  SizedBox(height: 30),
                  CustomTextField(
                    hintText: 'Full Name',
                    controller: fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: 'Date of Birth',
                        controller: dobController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Phone Number',
                    controller: phoneNumberController,
                    textInputType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'ID Number',
                    controller: idController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  buildUploadContainer(
                      title: "Upload ID (Cedula)",
                      images: cedulaImages,
                      isCedula: true),
                  SizedBox(height: 20),
                  buildUploadContainer(
                      title: "Upload Insurance (Seguro Médico)",
                      images: insuranceImages,
                      isCedula: false),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Address',
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Obx(() => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: Colors.green),
                          hintText: 'selectprovince'.tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        items:
                            locationController.provinceList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          locationController.fetchMunicipalities(value!);
                          setState(() {
                            selectedProvince = value;
                          });
                        },
                        value: locationController.selectedProvince.value.isEmpty
                            ? null
                            : locationController.selectedProvince.value,
                      )),
                  SizedBox(height: 20),
                  Obx(() => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_city, color: Colors.green),
                          hintText: 'selectmunicipality'.tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        items: locationController
                                    .selectedProvince.value.isNotEmpty &&
                                locationController.municipalityMap.containsKey(
                                    locationController.selectedProvince.value)
                            ? locationController.municipalityMap[
                                    locationController.selectedProvince.value]!
                                .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : [],
                        onChanged: (value) {
                          locationController.fetchSectors(value!);
                          setState(() {
                            selectedMunicipality = value;
                          });
                        },
                        value: locationController
                                .selectedMunicipality.value.isEmpty
                            ? null
                            : locationController.selectedMunicipality.value,
                      )),
                  SizedBox(height: 20),
                  Obx(() => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: Colors.green),
                          hintText: 'selectsector'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: locationController
                                    .selectedMunicipality.value.isNotEmpty &&
                                locationController.sectorMap.containsKey(
                                    locationController
                                        .selectedMunicipality.value)
                            ? locationController.sectorMap[locationController
                                    .selectedMunicipality.value]!
                                .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : [],
                        onChanged: (value) {
                          locationController.selectedSector.value = value!;
                          setState(() {
                            selectedSector = value;
                          });
                        },
                        value: locationController.selectedSector.value.isEmpty
                            ? null
                            : locationController.selectedSector.value,
                      )),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.green),
                      hintText: 'Gender',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: genders.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    value: selectedGender,
                    validator: (value) =>
                        value == null ? 'Please select gender' : null,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.accessibility, color: Colors.green),
                      hintText: 'Disability',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: disabilities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDisability = value;
                      });
                    },
                    value: selectedDisability,
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: isRegistering
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            if (cedulaImages.isEmpty) {
                              Get.snackbar("Error",
                                  "Please upload at least one ID (Cedula) image",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }

                            setState(() => isRegistering = true);
                            try {
                              if (widget.isEditMode == false) {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                              String userId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              print("Starting registration process...");

                              // 1. First authenticate the user
                              print("Creating user account...");

                              // 2. Upload images
                              print("Uploading images...");
                              List<String> uploadedCedulaUrls = [];
                              List<String> uploadedInsuranceUrls = [];

                              for (var i = 0; i < cedulaImages.length; i++) {
                                print(
                                    "Uploading cedula image ${i + 1} of ${cedulaImages.length}");
                                String imageUrl = await uploadFile(
                                    cedulaImages[i], "Cedula_Images");
                                if (imageUrl.isNotEmpty) {
                                  uploadedCedulaUrls.add(imageUrl);
                                }
                              }

                              for (var i = 0; i < insuranceImages.length; i++) {
                                print(
                                    "Uploading insurance image ${i + 1} of ${insuranceImages.length}");
                                String imageUrl = await uploadFile(
                                    insuranceImages[i], "Insurance_Images");
                                if (imageUrl.isNotEmpty) {
                                  uploadedInsuranceUrls.add(imageUrl);
                                }
                              }

                              // 3. Create patient profile
                              print("Creating patient model...");
                              final docRef = FirebaseFirestore.instance
                                  .collection('patients')
                                  .doc(userId);

                              var profile = PatientModel(
                                fullName: fullNameController.text.trim(),
                                dob: dobController.text.trim(),
                                phoneNumber: phoneNumberController.text.trim(),
                                id: idController.text.trim(),
                                state: selectedSector ?? '',
                                municipality: selectedMunicipality ?? '',
                                address: addressController.text.trim(),
                                gender: selectedGender ?? '',
                                disability: selectedDisability ?? '',
                                disabilityType: selectedDisability ?? '',
                                email: emailController.text.trim(),
                                documentId: docRef.id,
                                fcmToken: '',
                                profileImage: '',
                                provincia: selectedProvince ?? '',
                                sector: selectedSector ?? '',
                                status: 'active',
                                hasDisability: selectedDisability != null &&
                                    selectedDisability != 'None',
                                isOnline: false,
                                isProfileComplete: true,
                                lastSignOut: null,
                                lastTokenUpdate: null,
                                role: 'patient',
                                uid: userId,
                                updatedAt: DateTime.now(),
                                cedulaImages: uploadedCedulaUrls,
                                insuranceImages: uploadedInsuranceUrls,
                              );

                              print("Saving patient profile to Firestore...");
                              await docRef.set(profile.toMap());
                              await authController.completeProfile(profile);

                              print("Registration successful!");
                              Get.snackbar(
                                "Success",
                                "Profile completed successfully!",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );

                              // Navigate to home screen or wherever needed
                              // Get.offAll(() => HomeScreen());
                            } on FirebaseAuthException catch (e) {
                              String errorMessage = "Authentication failed";
                              if (e.code == 'weak-password') {
                                errorMessage =
                                    "The password provided is too weak.";
                              } else if (e.code == 'email-already-in-use') {
                                errorMessage =
                                    "The account already exists for that email.";
                              }
                              Get.snackbar("Error", errorMessage,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            } catch (e) {
                              print("Registration error: $e");
                              Get.snackbar("Error",
                                  "Registration failed: ${e.toString()}",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            } finally {
                              setState(() => isRegistering = false);
                            }
                          },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isRegistering
                        ? CircularProgressIndicator(color: Colors.white)
                        : CustomText(
                            text: widget.isEditMode
                                ? 'Update Profile'
                                : 'Complete Profile',
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUploadContainer({
    required String title,
    required List<dynamic> images,
    required bool isCedula,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => pickImages(isCedula),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Upload images from gallery',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          SizedBox(height: 10),
          images.isNotEmpty
              ? Wrap(
                  spacing: 8,
                  children: List.generate(images.length, (index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: kIsWeb && images[index] is Uint8List
                                  ? MemoryImage(images[index] as Uint8List)
                                  : FileImage(images[index] as File)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: IconButton(
                            icon:
                                Icon(Icons.cancel, color: Colors.red, size: 20),
                            onPressed: () => removeImage(index, isCedula),
                          ),
                        ),
                      ],
                    );
                  }),
                )
              : Text("No images selected",
                  style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
