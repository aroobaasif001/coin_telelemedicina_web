import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/AppTheme.dart';

class HealthCenterScreen extends StatefulWidget {
  @override
  _HealthCenterScreenState createState() => _HealthCenterScreenState();
}

class _HealthCenterScreenState extends State<HealthCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  List<String> selectedServices = [];
final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  bool isActive = true;
  bool isLoading = false;

  Map<String, Map<String, TimeOfDay?>> availability = {
    'monday': {'open': null, 'close': null},
    'tuesday': {'open': null, 'close': null},
    'wednesday': {'open': null, 'close': null},
    'thursday': {'open': null, 'close': null},
    'friday': {'open': null, 'close': null},
    'saturday': {'open': null, 'close': null},
    'sunday': {'open': null, 'close': null},
  };
List<String> accessibilityOptions = [
  'Priority Assistance / Asistencia prioritaria',
  'Wheelchair Ramp / Rampa de acceso',
  'Accessible Restrooms / Baños adaptados',
  'Sign Language Support / Atención en lengua de señas',
  'Elevator Available / Elevador disponible',
  'Accessible Parking / Estacionamiento accesible',
  'Wheelchairs Available / Sillas de ruedas disponibles',
];

List<String> selectedAccessibilityOptions = [];

  Future<void> _selectTime(
      BuildContext context, String day, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: availability[day]![type] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        availability[day]![type] = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final formattedAvailability = availability.map((day, times) => MapEntry(
            day,
            {
              'open': times['open']?.format(context) ?? '',
              'close': times['close']?.format(context) ?? '',
            },
          ));

      await FirebaseFirestore.instance.collection('healthCenters').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'municipality': _municipalityController.text,
        'province': _provinceController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'website': _websiteController.text,
        'description': _descriptionController.text,
        'sector': _sectorController.text,
        'services': selectedServices,
         'accessibilityOptions': selectedAccessibilityOptions,
        'isActive': isActive,
        'availability': formattedAvailability,
         'coordinates': {
          'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
          'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
        },
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health Center saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text('Add Health Center ',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
      body: CustomContainer(
        conColor: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(_nameController, 'Name'),
                  _buildTextField(_addressController, 'Address'),
                  _buildTextField(_cityController, 'City'),
                  _buildTextField(_municipalityController, 'Municipality'),
                  _buildTextField(_provinceController, 'Province'),
                  _buildTextField(_phoneController, 'Phone'),
                  _buildTextField(_emailController, 'Email'),
                  _buildTextField(_websiteController, 'Website'),
                  _buildTextField(_descriptionController, 'Description'),
                  _buildTextField(_sectorController, 'Sector'),
                   _buildTextField(_latitudeController, 'Latitude'),
                  _buildTextField(_longitudeController, 'Longitude'),
                  const SizedBox(height: 20),
                  const Text('Select Services',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 5,
                    children: [
                      'Cardiology',
                      'General Medicine',
                      'Pediatrics',
                      'Psychology'
                    ].map((service) {
                      return FilterChip(
                        label: Text(service),
                        selected: selectedServices.contains(service),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedServices.add(service);
                            } else {
                              selectedServices.remove(service);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
        const Text('Accessibility Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 5,
          children: accessibilityOptions.map((option) {
            return FilterChip(
        label: Text(option),
        selected: selectedAccessibilityOptions.contains(option),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              selectedAccessibilityOptions.add(option);
            } else {
              selectedAccessibilityOptions.remove(option);
            }
          });
        },
            );
          }).toList(),
        ),
        SizedBox(height: 20,),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Availability',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...availability.keys.map((day) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _selectTime(context, day, 'open'),
                                child: Text(
                                  availability[day]!['open']?.format(context) ??
                                      'Select Open Time',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _selectTime(context, day, 'close'),
                                child: Text(
                                  availability[day]!['close']?.format(context) ??
                                      'Select Close Time',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}

