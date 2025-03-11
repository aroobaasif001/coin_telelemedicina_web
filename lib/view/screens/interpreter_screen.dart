import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';

class InterpreterScreen extends StatefulWidget {
  const InterpreterScreen({super.key});

  @override
  State<InterpreterScreen> createState() => _InterpreterScreenState();
}

class _InterpreterScreenState extends State<InterpreterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _healthCenterIdController = TextEditingController();
  List<String> selectedLanguages = ['Spanish'];
  List<String> selectedInterpreterTypes = ['sign-language'];

  final List<String> availableLanguages = [
    'Spanish',
    'Sign Language',
    'English',
    'French',
  ];

  final List<String> availableInterpreterTypes = [
    'sign-language',
    'english',
    'french',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(title: 'Interpreter Screen'),
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
                          text: 'Interpreter Profile Form',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: AppTheme.spacing24),
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
                            hintText: 'Ana Martinez',
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
                            hintText: 'Certified sign language interpreter with experience in medical settings.',
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
                            hintText: 'Dominican Sign Language Certification',
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
                            hintText: '5',
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
                        const SizedBox(height: AppTheme.spacing24),

                        // Interpreter Types
                        const CustomText(
                          text: 'Interpreter Types',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        Wrap(
                          spacing: 8,
                          children: availableInterpreterTypes.map((type) {
                            return FilterChip(
                              label: Text(type.toUpperCase()),
                              selected: selectedInterpreterTypes.contains(type),
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
                        const SizedBox(height: AppTheme.spacing16),

                        // Languages
                        const CustomText(
                          text: 'Languages',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        Wrap(
                          spacing: 8,
                          children: availableLanguages.map((language) {
                            return FilterChip(
                              label: Text(language),
                              selected: selectedLanguages.contains(language),
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