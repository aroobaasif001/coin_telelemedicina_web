import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      // Convert TimeOfDay to String
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
        'isActive': isActive,
        'availability': formattedAvailability,
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
        title: const Text('Health Center Form'),
      ),
      body: Padding(
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
