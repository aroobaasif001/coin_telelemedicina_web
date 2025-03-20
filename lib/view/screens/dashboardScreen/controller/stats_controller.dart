import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var patientCount = 0.obs;
  var doctorCount = 0.obs;
  var serviceCount = 0.obs;
  var appointmentCount = 0.obs;
  var completedAppointments = 0.obs;
  var companiesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      var patientsSnapshot = await _firestore.collection('patients').get();
      var doctorsSnapshot = await _firestore.collection('providers').get();
      var servicesSnapshot = await _firestore.collection('services').get();
      var appointmentsSnapshot = await _firestore.collection('appointments').get();
      var completedAppointmentsSnapshot = await _firestore
          .collection('appointments')
          .where('status', isEqualTo: 'completed')
          .get();
      var companiesSnapshot = await _firestore.collection('interpreterProfiles').get();

      patientCount.value = patientsSnapshot.docs.length;
      doctorCount.value = doctorsSnapshot.docs.length;
      serviceCount.value = servicesSnapshot.docs.length;
      appointmentCount.value = appointmentsSnapshot.docs.length;
      completedAppointments.value = completedAppointmentsSnapshot.docs.length;
      companiesCount.value = companiesSnapshot.docs.length;
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }
}
