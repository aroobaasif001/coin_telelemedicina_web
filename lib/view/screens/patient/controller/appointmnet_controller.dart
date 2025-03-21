import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var upcomingAppointments = <Map<String, dynamic>>[].obs;
  var pastAppointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  void fetchAppointments() async {
    FirebaseFirestore.instance.collection('appointments').snapshots().listen((snapshot) {
      List<Map<String, dynamic>> upcoming = [];
      List<Map<String, dynamic>> history = [];
      DateTime now = DateTime.now();

      for (var doc in snapshot.docs) {
        var data = doc.data();
        Timestamp timestamp = data['appointmentDate']; // Ensure field name matches Firestore
        DateTime appointmentDate = timestamp.toDate();

        if (appointmentDate.isAfter(now)) {
          upcoming.add(data);
        } else {
          history.add(data);
        }
      }

      upcomingAppointments.value = upcoming;
      pastAppointments.value = history;
    });
  }
  
}
