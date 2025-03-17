import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../model/service_model.dart';

class ServiceController extends GetxController {
  var isLoading = false.obs;
  var requiresInterpreter = false.obs;
  var supportedInterpreterTypes = <String>[].obs;

  Future<void> addService(Map<String, dynamic> serviceData) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance.collection('services').doc(serviceData['id']).set(serviceData);
      Get.snackbar('Success', 'Service added successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var services = <ServiceModel>[].obs; // List of services
 // Loading state

  @override
  void onInit() {
    super.onInit();
    fetchServices(); // Load services on startup
  }

  void fetchServices() {
    _firestore.collection('services').snapshots().listen((snapshot) {
      services.value = snapshot.docs.map((doc) {
        return ServiceModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      isLoading(false);
    });
  }
}
