import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
}
