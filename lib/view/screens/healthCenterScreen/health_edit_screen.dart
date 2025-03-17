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

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _municipalityController;
  late TextEditingController _provinceController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _descriptionController;
  late TextEditingController _sectorController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
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
        SnackBar(content: Text('Health Center updated successfully!')),
      );

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Health Center',style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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

                // 📍 Latitude & Longitude (Editable)
                _buildTextField(_latitudeController, 'Latitude'),
                _buildTextField(_longitudeController, 'Longitude'),

                SizedBox(height: 20),
                Text('Select Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 5,
                  children: ['Cardiology', 'General Medicine', 'Pediatrics', 'Psychology'].map((service) {
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

                SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Active'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),

                SizedBox(height: 20),
                Text('Availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              child: Text(availability[day]!['open'] ?? 'Select Open Time'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _selectTime(context, day, 'close'),
                              child: Text(availability[day]!['close'] ?? 'Select Close Time'),
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
                    child: Text('Save Changes', style: TextStyle(fontSize: 16, color: Colors.white)),
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
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
