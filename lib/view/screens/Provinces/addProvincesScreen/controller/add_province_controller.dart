import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProvinceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var provinces = <Map<String, dynamic>>[].obs;
  var municipalities = <Map<String, dynamic>>[].obs;
  var sectors = <Map<String, dynamic>>[].obs;
  var selectedProvince = ''.obs;
  var selectedMunicipality = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProvinces(); 
  }

  void fetchProvinces() {
    _firestore.collection('provinces').snapshots().listen((snapshot) {
      provinces.value = snapshot.docs.map((doc) => {
            "id": doc.id,
            "name": doc["name"],
            "isActive": doc["isActive"] ?? true,
          }).toList();
    });
  }

  void fetchMunicipalities(String provinceId) {
    selectedMunicipality.value = ''; 
    _firestore
        .collection('provinces')
        .doc(provinceId)
        .collection('municipalities')
        .snapshots()
        .listen((snapshot) {
      municipalities.value = snapshot.docs.map((doc) => {
            "id": doc.id,
            "name": doc["name"],
            "isActive": doc["isActive"] ?? true,
          }).toList();
    });
  }

  void fetchSectors(String provinceId, String municipalityId) {
    _firestore
        .collection('provinces')
        .doc(provinceId)
        .collection('municipalities')
        .doc(municipalityId)
        .collection('sectors')
        .snapshots()
        .listen((snapshot) {
      sectors.value = snapshot.docs.map((doc) => {
            "id": doc.id,
            "name": doc["name"],
            "isActive": doc["isActive"] ?? true,
          }).toList();
    });
  }

  Future<void> addProvince(String provinceName) async {
    try {
      String provinceId = provinceName.trim().toLowerCase().replaceAll(" ", "-");

      var existingProvince = await _firestore.collection('provinces').doc(provinceId).get();
      if (existingProvince.exists) {
        Get.snackbar("Error", "Province already exists!");
        return;
      }

      await _firestore.collection('provinces').doc(provinceId).set({
        "name": provinceName,
        "isActive": true,
      });

      Get.snackbar("Success", "Province Added Successfully");
      fetchProvinces(); 
    } catch (e) {
      print("Error adding province: $e");
      Get.snackbar("Error", "Failed to add province");
    }
  }

  Future<void> addMunicipality(String provinceId, String municipalityName) async {
    try {
      String municipalityId = municipalityName.trim().toLowerCase().replaceAll(" ", "-");

      var existingMunicipality = await _firestore
          .collection('provinces')
          .doc(provinceId)
          .collection('municipalities')
          .doc(municipalityId)
          .get();

      if (existingMunicipality.exists) {
        Get.snackbar("Error", "Municipality already exists!");
        return;
      }

      await _firestore
          .collection('provinces')
          .doc(provinceId)
          .collection('municipalities')
          .doc(municipalityId)
          .set({
        "name": municipalityName,
        "isActive": true,
      });

      Get.snackbar("Success", "Municipality Added Successfully");
      fetchMunicipalities(provinceId);
    } catch (e) {
      print("Error adding municipality: $e");
      Get.snackbar("Error", "Failed to add municipality");
    }
  }

  Future<void> addSector(String provinceId, String municipalityId, String sectorName) async {
    try {
      String sectorId = sectorName.trim().toLowerCase().replaceAll(" ", "-");

      var existingSector = await _firestore
          .collection('provinces')
          .doc(provinceId)
          .collection('municipalities')
          .doc(municipalityId)
          .collection('sectors')
          .doc(sectorId)
          .get();

      if (existingSector.exists) {
        Get.snackbar("Error", "Sector already exists!");
        return;
      }

      await _firestore
          .collection('provinces')
          .doc(provinceId)
          .collection('municipalities')
          .doc(municipalityId)
          .collection('sectors')
          .doc(sectorId)
          .set({
        "name": sectorName,
        "isActive": true,
      });

      Get.snackbar("Success", "Sector Added Successfully");
      fetchSectors(provinceId, municipalityId);
    } catch (e) {
      print("Error adding sector: $e");
      Get.snackbar("Error", "Failed to add sector");
    }
  }

  Future<void> deleteProvince(String provinceId) async {
    try {
      await _firestore.collection('provinces').doc(provinceId).delete();
      fetchProvinces();
      Get.snackbar("Success", "Province Deleted Successfully");
    } catch (e) {
      print("Error deleting province: $e");
      Get.snackbar("Error", "Failed to delete province");
    }
  }
}
