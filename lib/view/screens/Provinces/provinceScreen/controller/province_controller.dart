

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProvinceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var provinces = <Map<String, dynamic>>[].obs;
  var municipalities = <String, List<Map<String, dynamic>>>{}.obs;
  var sectors = <Map<String, dynamic>>[].obs;
 var searchQuery = ''.obs;
  var selectedProvince = ''.obs;
  var selectedMunicipality = ''.obs;
 var selectedProvinceFilter = ''.obs;
   var selectedMunicipalityFilter = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchProvinces();
  }

  // void fetchProvinces() {
  //   _firestore.collection('provinces').snapshots().listen((snapshot) {
  //     provinces.value = snapshot.docs.map((doc) => {
  //           "id": doc.id,
  //           "name": doc["name"],
  //         }).toList();
  //   });
  // }

  void fetchProvinces() {
  _firestore.collection('provinces').snapshots().listen((snapshot) async {
    List<Map<String, dynamic>> provinceList = [];

    for (var doc in snapshot.docs) {
      var provinceData = {
        "id": doc.id,
        "name": doc["name"],
        "municipalities": 0.obs, // 🔥 Make it an observable integer
      };

      var municipalitiesSnapshot = await _firestore
          .collection('provinces')
          .doc(doc.id)
          .collection('municipalities')
          .get();

      provinceData["municipalities"].value = municipalitiesSnapshot.docs.length;

      provinceList.add(provinceData);
    }

    provinces.value = provinceList; // ✅ Update state once fetched
  });
}

  List<Map<String, dynamic>> get filteredProvinces {
    if (searchQuery.value.isEmpty) {
      return provinces;
    }
    return provinces
        .where((province) =>
            province["name"].toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
  // void fetchMunicipalities(String provinceId) {
  //   _firestore
  //       .collection('provinces')
  //       .doc(provinceId)
  //       .collection('municipalities')
  //       .snapshots()
  //       .listen((snapshot) {
  //     municipalities.value = snapshot.docs.map((doc) => {
  //           "id": doc.id,
  //           "name": doc["name"],
  //         }).toList();
  //   });
  // }
  void fetchMunicipalities(String provinceId) {
  _firestore
      .collection('provinces')
      .doc(provinceId)
      .collection('municipalities')
      .snapshots()
      .listen((snapshot) {
    municipalities[provinceId] = snapshot.docs
        .map((doc) => {"id": doc.id, "name": doc["name"]})
        .toList();
  });
}

  Future<void> deleteProvince(String provinceId) async {
    await _firestore.collection('provinces').doc(provinceId).delete();
    fetchProvinces(); // Refresh data
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
          }).toList();
    });
  }
}
