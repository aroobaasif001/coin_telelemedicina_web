import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDisabilityController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var disabilities = <Map<String, dynamic>>[].obs;
  var selectedDisability = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisabilities();
  }

  // Fetch Disabilities from Firestore
  Future<void> fetchDisabilities() async {
    try {
      var snapshot = await _firestore.collection('disabilities').get();
      disabilities.value = snapshot.docs.map((doc) => {
            "id": doc.id,
            "name": doc["name"],
          }).toList();
      update();
    } catch (e) {
      print("Error fetching disabilities: $e");
    }
  }

  // Add a New Disability
  Future<void> addDisability(String disabilityName) async {
    try {
      String disabilityId = disabilityName.trim().toLowerCase().replaceAll(" ", "-");

      await _firestore.collection('disabilities').doc(disabilityId).set({
        "name": disabilityName,
        "isActive": true,
      });

      fetchDisabilities(); // Refresh List
      Get.snackbar("Success", "Disability Added Successfully");
    } catch (e) {
      print("Error adding disability: $e");
      Get.snackbar("Error", "Failed to add disability");
    }
  }

  // Add a New Disability Type
  Future<void> addDisabilityType(String disabilityId, String typeName) async {
    try {
      String typeId = typeName.trim().toLowerCase().replaceAll(" ", "-");

      await _firestore.collection('disabilityTypes').doc(typeId).set({
        "name": typeName,
        "disabilityId": disabilityId,
        "isActive": true,
      });

      Get.snackbar("Success", "Disability Type Added Successfully");
    } catch (e) {
      print("Error adding disability type: $e");
      Get.snackbar("Error", "Failed to add disability type");
    }
  }
}
