import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<DoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _healthCenterIdController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  bool isVerified = true;
  List<String> languages = ['español'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _biographyController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _healthCenterIdController.dispose();
    _photoUrlController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Center(
                child: CustomContainer(
                  width: double.maxFinite,
                  conColor: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                    )
                  ],
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Doctor Profile Form',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: AppTheme.spacing24),
                        // Photo URL Field
                        Center(
                          child: CircleAvatar(
                            radius: 80,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Full Name Field
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Dra. María Rodríguez',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Biography Field
                        TextFormField(
                          controller: _biographyController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Biography',
                            hintText: 'Pediatra especializado en desarrollo infantil y adolescente.',
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter biography';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Education Field
                        TextFormField(
                          controller: _educationController,
                          decoration: const InputDecoration(
                            labelText: 'Education',
                            hintText: 'Universidad Iberoamericana (UNIBE)',
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter education';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Experience Field
                        TextFormField(
                          controller: _experienceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Years of Experience',
                            hintText: '12',
                            prefixIcon: Icon(Icons.work_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter years of experience';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Health Center ID Field
                        TextFormField(
                          controller: _healthCenterIdController,
                          decoration: const InputDecoration(
                            labelText: 'Health Center ID',
                            hintText: 'coin',
                            prefixIcon: Icon(Icons.local_hospital_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter health center ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),

                        // Specialty Field
                        TextFormField(
                          controller: _specialtyController,
                          decoration: const InputDecoration(
                            labelText: 'Specialty',
                            hintText: 'Pediatría',
                            prefixIcon: Icon(Icons.medical_services_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter specialty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing32),

                        // Submit Button
                        Center(
                          child: MaterialButton(
                            color: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle form submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              child: CustomText(
                                text: 'Submit',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 