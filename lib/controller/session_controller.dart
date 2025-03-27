import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SessionController extends GetxController {
  final _storage = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoggedIn = false.obs;
  final Rx<Map<String, dynamic>?> currentAdmin =
      Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final adminData = _storage.read('admin_data');
    if (adminData != null) {
      currentAdmin.value = Map<String, dynamic>.from(adminData);
      isLoggedIn.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final adminDoc = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (adminDoc.docs.isNotEmpty) {
        final adminData = adminDoc.docs.first.data();
        currentAdmin.value = adminData;
        _storage.write('admin_data', adminData);
        isLoggedIn.value = true;
        return true;
      }
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  void logout() {
    _storage.remove('admin_data');
    currentAdmin.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  // Getter para obtener información del admin actual
  String get adminName => currentAdmin.value?['name'] ?? '';
  String get adminEmail => currentAdmin.value?['email'] ?? '';
}
