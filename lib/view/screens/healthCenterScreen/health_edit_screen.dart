

import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:coin_telelemedicina_web/model/health_center_model.dart';

class HealthCenterEditScreen extends StatefulWidget {
  final HealthCenterModel center;

  HealthCenterEditScreen({required this.center});

  @override
  _HealthCenterEditScreenState createState() => _HealthCenterEditScreenState();
}

class _HealthCenterEditScreenState extends State<HealthCenterEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController, _addressController, _cityController, _municipalityController;
  late TextEditingController _provinceController, _phoneController, _emailController, _websiteController;
  late TextEditingController _descriptionController, _sectorController, _latitudeController, _longitudeController;

  bool _isActive = true;
  List<String> selectedServices = [];
  Map<String, Map<String, String>> availability = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.center.name);
    _addressController = TextEditingController(text: widget.center.address);
    _cityController = TextEditingController(text: widget.center.city);
    _municipalityController = TextEditingController(text: widget.center.municipality);
    _provinceController = TextEditingController(text: widget.center.province);
    _phoneController = TextEditingController(text: widget.center.phone);
    _emailController = TextEditingController(text: widget.center.email);
    _websiteController = TextEditingController(text: widget.center.website);
    _descriptionController = TextEditingController(text: widget.center.description);
    _sectorController = TextEditingController(text: widget.center.sector);
    _latitudeController = TextEditingController(text: widget.center.latitude.toString());
    _longitudeController = TextEditingController(text: widget.center.longitude.toString());
    _isActive = widget.center.isActive;
    selectedServices = List.from(widget.center.services);
    availability = Map.from(widget.center.availability);
  }

  Future<void> _selectTime(BuildContext context, String day, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: availability[day]![type]!.isNotEmpty
          ? TimeOfDay(
          hour: int.parse(availability[day]![type]!.split(":")[0]),
          minute: int.parse(availability[day]![type]!.split(":")[1].split(" ")[0]))
          : TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        availability[day]![type] = "${picked.hour}:${picked.minute} ${picked.period == DayPeriod.am ? 'AM' : 'PM'}";
      });
    }
  }

  Future<void> _updateHealthCenter() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('healthCenters').doc(widget.center.id).update({
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
        'isActive': _isActive,
        'coordinates': {
          'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
          'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
        },
        'availability': availability,
        'updatedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('health_center_updated'.tr)),
      );

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit_health_center'.tr, style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'name'.tr),
                _buildTextField(_addressController, 'address'.tr),
                _buildTextField(_cityController, 'city'.tr),
                _buildTextField(_municipalityController, 'municipality'.tr),
                _buildTextField(_provinceController, 'province'.tr),
                _buildTextField(_phoneController, 'phone'.tr),
                _buildTextField(_emailController, 'email'.tr),
                _buildTextField(_websiteController, 'website'.tr),
                _buildTextField(_descriptionController, 'description'.tr),
                _buildTextField(_sectorController, 'sector'.tr),
                _buildTextField(_latitudeController, 'latitude'.tr),
                _buildTextField(_longitudeController, 'longitude'.tr),

                SizedBox(height: 20),
                Text('select_services'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 5,
                  children: ['Cardiology', 'General Medicine', 'Pediatrics', 'Psychology'].map((service) {
                    return FilterChip(
                      label: Text(service.tr),
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

                SizedBox(height: 20),
                SwitchListTile(
                  title: Text('active'.tr),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),

                SizedBox(height: 20),
                Text('availability'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...availability.keys.map((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(day.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _selectTime(context, day, 'open'),
                              child: Text(availability[day]!['open'] ?? 'select_open_time'.tr),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _selectTime(context, day, 'close'),
                              child: Text(availability[day]!['close'] ?? 'select_close_time'.tr),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  );
                }).toList(),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateHealthCenter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('save_changes'.tr, style: TextStyle(fontSize: 16, color: Colors.white)),
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
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? 'please_enter'.trParams({'field': label}) : null,
      ),
    );
  }
}
