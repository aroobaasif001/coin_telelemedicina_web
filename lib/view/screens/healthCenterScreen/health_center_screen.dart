import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/AppTheme.dart';
import '../patient/controller/localization_controller.dart';

class HealthCenterScreen extends StatefulWidget {
  @override
  _HealthCenterScreenState createState() => _HealthCenterScreenState();
}

class _HealthCenterScreenState extends State<HealthCenterScreen> {
  final LocationController locationController = Get.put(LocationController());
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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  List<String> selectedServices = [];
  List<String> selectedAccessibilityOptions = [];
  String? selectedProvince;
  String? selectedMunicipality;
  String? selectedSector;
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
    'Priority Assistance',
    'Wheelchair Ramp',
    'Accessible Restrooms',
    'Sign Language Support',
    'Elevator Available',
    'Accessible Parking',
    'Wheelchairs Available',
  ];

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
      setState(() => isLoading = true);

      final formattedAvailability = availability.map((day, times) => MapEntry(
            day,
            {
              'open': times['open']?.format(context) ?? '',
              'close': times['close']?.format(context) ?? '',
            },
          ));

      DocumentReference healthCenterRef =
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
        'coordinates': {
          'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
          'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
        },
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      for (var option in accessibilityOptions) {
        await FirebaseFirestore.instance
            .collection('accessibilityOptions')
            .doc(option.toLowerCase().replaceAll(' ', '-'))
            .set({
          'name': option,
          'isActive': selectedAccessibilityOptions.contains(option),
          'healthCenterId': healthCenterRef.id,
          'createdAt': DateTime.now(),
        });
      }

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('health_center_saved'.tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('add_health_center'.tr,
              style: TextStyle(color: Colors.white)),
          backgroundColor: AppTheme.primaryColor),
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
                  _buildTextField(_nameController, 'name'.tr),
                  _buildTextField(_addressController, 'address'.tr),
                  _buildTextField(_cityController, 'city'.tr),
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
                            child: Text(
                              value
                                  .split(' ')
                                  .map((word) => word.isNotEmpty
                                      ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                      : '')
                                  .join(' '),
                            ),
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
                                  child: Text(
                                    value
                                        .split(' ')
                                        .map((word) => word.isNotEmpty
                                            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                            : '')
                                        .join(' '),
                                  ),
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
                                  child: Text(
                                    value
                                        .split(' ')
                                        .map((word) => word.isNotEmpty
                                            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                            : '')
                                        .join(' '),
                                  ),
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
                  const SizedBox(height: 20),
                  _buildTextField(_phoneController, 'phone'.tr),
                  _buildTextField(_emailController, 'email'.tr),
                  _buildTextField(_websiteController, 'website'.tr),
                  _buildTextField(_descriptionController, 'description'.tr),
                  _buildTextField(_latitudeController, 'latitude'.tr),
                  _buildTextField(_longitudeController, 'longitude'.tr),
                  const SizedBox(height: 20),
                  Text('select_services'.tr,
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
                            selected
                                ? selectedServices.add(service)
                                : selectedServices.remove(service);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('accessibility_options'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 5,
                    children: accessibilityOptions.map((option) {
                      return FilterChip(
                        label: Text(option),
                        selected: selectedAccessibilityOptions.contains(option),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? selectedAccessibilityOptions.add(option)
                                : selectedAccessibilityOptions.remove(option);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  SwitchListTile(
                    title: Text('active'.tr),
                    value: isActive,
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                  SizedBox(height: 20),
                  Text('availability'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...availability.keys.map((day) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day.tr,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _selectTime(context, day, 'open'),
                                child: Text(
                                  availability[day]!['open']?.format(context) ??
                                      'select_open_time'.tr,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _selectTime(context, day, 'close'),
                                child: Text(
                                  availability[day]!['close']
                                          ?.format(context) ??
                                      'select_close_time'.tr,
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
                          : Text('submit'.tr,
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
        validator: (value) => value!.isEmpty ? 'enter'.tr + ' $label' : null,
      ),
    );
  }
}

///

// import 'package:coin_telelemedicina_web/widget/custom_container.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import '../../../utils/AppTheme.dart';
// import 'controller/health_center_controller.dart';
//
// class HealthCenterScreen extends StatefulWidget {
//   @override
//   _HealthCenterScreenState createState() => _HealthCenterScreenState();
// }
//
// class _HealthCenterScreenState extends State<HealthCenterScreen> {
//   HealthCenterController healthCenterController = HealthCenterController();
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _municipalityController = TextEditingController();
//   final TextEditingController _provinceController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _websiteController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _sectorController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();
//   List<String> selectedServices = [];
//   List<String> selectedAccessibilityOptions = [];
//   bool isActive = true;
//   bool isLoading = false;
//   String? selectedProvince;
//   String? selectedMunicipality;
//   String? selectedSector;
//
//   Map<String, Map<String, TimeOfDay?>> availability = {
//     'monday': {'open': null, 'close': null},
//     'tuesday': {'open': null, 'close': null},
//     'wednesday': {'open': null, 'close': null},
//     'thursday': {'open': null, 'close': null},
//     'friday': {'open': null, 'close': null},
//     'saturday': {'open': null, 'close': null},
//     'sunday': {'open': null, 'close': null},
//   };
//
//   List<String> accessibilityOptions = [
//     'Priority Assistance',
//     'Wheelchair Ramp',
//     'Accessible Restrooms',
//     'Sign Language Support',
//     'Elevator Available',
//     'Accessible Parking',
//     'Wheelchairs Available',
//   ];
//
//   Future<void> _selectTime(BuildContext context, String day, String type) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: availability[day]![type] ?? TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         availability[day]![type] = picked;
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => isLoading = true);
//
//       final formattedAvailability = availability.map((day, times) => MapEntry(
//             day,
//             {
//               'open': times['open']?.format(context) ?? '',
//               'close': times['close']?.format(context) ?? '',
//             },
//           ));
//
//       DocumentReference healthCenterRef = await FirebaseFirestore.instance.collection('healthCenters').add({
//         'name': _nameController.text,
//         'address': _addressController.text,
//         'city': _cityController.text,
//         'municipality': _municipalityController.text,
//         'province': _provinceController.text,
//         'phone': _phoneController.text,
//         'email': _emailController.text,
//         'website': _websiteController.text,
//         'description': _descriptionController.text,
//         'sector': _sectorController.text,
//         'services': selectedServices,
//         'isActive': isActive,
//         'availability': formattedAvailability,
//         'coordinates': {
//           'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
//           'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
//         },
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//       });
//
//       for (var option in accessibilityOptions) {
//         await FirebaseFirestore.instance
//             .collection('accessibilityOptions')
//             .doc(option.toLowerCase().replaceAll(' ', '-'))
//             .set({
//           'name': option,
//           'isActive': selectedAccessibilityOptions.contains(option),
//           'healthCenterId': healthCenterRef.id,
//           'createdAt': DateTime.now(),
//         });
//       }
//
//       setState(() => isLoading = false);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('health_center_saved'.tr)),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: Text('add_health_center'.tr, style: TextStyle(color: Colors.white)),
//           backgroundColor: AppTheme.primaryColor),
//       body: CustomContainer(
//         conColor: Colors.white,
//         margin: EdgeInsets.all(10),
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildTextField(_nameController, 'name'.tr),
//                   _buildTextField(_addressController, 'address'.tr),
//                   _buildTextField(_cityController, 'city'.tr),
//                   // _buildTextField(_municipalityController, 'municipality'.tr),
//                   // _buildTextField(_provinceController, 'province'.tr),
//                   Obx(() => DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.location_on, color: Colors.green),
//                       hintText: 'selectprovince'.tr,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     items: healthCenterController.provinceList.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(
//                           value.split(' ').map((word) => word.isNotEmpty
//                               ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//                               : '').join(' '),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       healthCenterController.fetchMunicipalities(value!);
//                       setState(() {
//                         selectedProvince = value;
//                       });
//                     },
//                     value: healthCenterController.selectedProvince.value.isEmpty
//                         ? null
//                         : healthCenterController.selectedProvince.value,
//                   )),
//                   SizedBox(height: 20),
//                   Obx(() => DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.location_city, color: Colors.green),
//                       hintText: 'selectmunicipality'.tr,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     items: healthCenterController.selectedProvince.value.isNotEmpty &&
//                         healthCenterController.municipalityMap.containsKey(
//                             healthCenterController.selectedProvince.value)
//                         ? healthCenterController.municipalityMap[
//                     healthCenterController.selectedProvince.value]!
//                         .map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(
//                           value.split(' ').map((word) => word.isNotEmpty
//                               ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//                               : '').join(' '),
//                         ),
//                       );
//                     }).toList()
//                         : [],
//                     onChanged: (value) {
//                       healthCenterController.fetchSectors(value!);
//                       setState(() {
//                         selectedMunicipality = value;
//                       });
//                     },
//                     value: healthCenterController.selectedMunicipality.value.isEmpty
//                         ? null
//                         : healthCenterController.selectedMunicipality.value,
//                   )),
//                   SizedBox(height: 20),
//                   Obx(() => DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.location_on_outlined, color: Colors.green),
//                       hintText: 'selectsector'.tr,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     items: healthCenterController.selectedMunicipality.value.isNotEmpty &&
//                         healthCenterController.sectorMap.containsKey(
//                             healthCenterController.selectedMunicipality.value)
//                         ? healthCenterController.sectorMap[
//                     healthCenterController.selectedMunicipality.value]!
//                         .map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(
//                           value.split(' ').map((word) => word.isNotEmpty
//                               ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//                               : '').join(' '),
//                         ),
//                       );
//                     }).toList()
//                         : [],
//                     onChanged: (value) {
//                       healthCenterController.selectedSector.value = value!;
//                       setState(() {
//                         selectedSector = value;
//                       });
//                     },
//                     value: healthCenterController.selectedSector.value.isEmpty
//                         ? null
//                         : healthCenterController.selectedSector.value,
//                   )),
//                   _buildTextField(_phoneController, 'phone'.tr),
//                   _buildTextField(_emailController, 'email'.tr),
//                   _buildTextField(_websiteController, 'website'.tr),
//                   _buildTextField(_descriptionController, 'description'.tr),
//                   _buildTextField(_sectorController, 'sector'.tr),
//                   _buildTextField(_latitudeController, 'latitude'.tr),
//                   _buildTextField(_longitudeController, 'longitude'.tr),
//                   const SizedBox(height: 20),
//                   Text('select_services'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   Wrap(
//                     spacing: 5,
//                     children: ['Cardiology', 'General Medicine', 'Pediatrics', 'Psychology'].map((service) {
//                       return FilterChip(
//                         label: Text(service),
//                         selected: selectedServices.contains(service),
//                         onSelected: (selected) {
//                           setState(() {
//                             selected ? selectedServices.add(service) : selectedServices.remove(service);
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   Text('accessibility_options'.tr,
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   Wrap(
//                     spacing: 5,
//                     children: accessibilityOptions.map((option) {
//                       return FilterChip(
//                         label: Text(option),
//                         selected: selectedAccessibilityOptions.contains(option),
//                         onSelected: (selected) {
//                           setState(() {
//                             selected
//                                 ? selectedAccessibilityOptions.add(option)
//                                 : selectedAccessibilityOptions.remove(option);
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//                   SwitchListTile(
//                     title: Text('active'.tr),
//                     value: isActive,
//                     onChanged: (value) => setState(() => isActive = value),
//                   ),
//                   SizedBox(height: 20),
//                   Text('availability'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   ...availability.keys.map((day) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(day.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: () => _selectTime(context, day, 'open'),
//                                 child: Text(
//                                   availability[day]!['open']?.format(context) ?? 'select_open_time'.tr,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: () => _selectTime(context, day, 'close'),
//                                 child: Text(
//                                   availability[day]!['close']?.format(context) ?? 'select_close_time'.tr,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                     );
//                   }).toList(),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : _submitForm,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text('submit'.tr, style: TextStyle(fontSize: 16, color: Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) => value!.isEmpty ? 'enter'.tr + ' $label' : null,
//       ),
//     );
//   }
// }
