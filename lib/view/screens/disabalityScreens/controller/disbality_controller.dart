
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DisabilityController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var disabilities = <Map<String, dynamic>>[].obs;
  var types = <Map<String, dynamic>>[].obs;
  var filteredDisabilities = <Map<String, dynamic>>[].obs;

  var searchQuery = ''.obs;
  var selectedDisabilityFilter = ''.obs;
  var selectedTypeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisabilitiesWithTypeCount();
    fetchDisabilityTypes();
    ever(searchQuery, (_) => applyFilters());
  }

  // ✅ Fetch Disabilities with Type count
  Future<void> fetchDisabilitiesWithTypeCount() async {
    try {
      QuerySnapshot disabilitiesSnapshot = await _firestore.collection('disabilities').get();

      List<Map<String, dynamic>> disabilitiesWithCount = [];

      for (var disabilityDoc in disabilitiesSnapshot.docs) {
        String disabilityId = disabilityDoc.id;

        QuerySnapshot typesSnapshot = await _firestore
            .collection('disabilityTypes')
            .where('disabilityId', isEqualTo: disabilityId)
            .get();

        disabilitiesWithCount.add({
          "id": disabilityId,
          "name": disabilityDoc["name"],
          "types": typesSnapshot.docs.length, // Total count of types
        });
      }

      disabilities.assignAll(disabilitiesWithCount);
      applyFilters();
    } catch (e) {
      print("Error fetching disabilities: $e");
    }
  }

  // ✅ Fetch All Disability Types
  Future<void> fetchDisabilityTypes() async {
    try {
      var snapshot = await _firestore.collection('disabilityTypes').get();
      types.value = snapshot.docs.map((doc) => {
        "id": doc.id,
        "name": doc["name"],
        "disabilityId": doc["disabilityId"],
        "isActive": doc["isActive"],
      }).toList();
      update();
    } catch (e) {
      print("Error fetching types: $e");
    }
  }

  // ✅ Fetch types for a specific disability
  Future<List<Map<String, dynamic>>> fetchTypesForDisability(String disabilityId) async {
    try {
      var snapshot = await _firestore
          .collection('disabilityTypes')
          .where('disabilityId', isEqualTo: disabilityId)
          .get();

      return snapshot.docs.map((doc) => {
        "id": doc.id,
        "name": doc["name"],
        "isActive": doc["isActive"],
      }).toList();
    } catch (e) {
      print("Error fetching types: $e");
      return [];
    }
  }

  // ✅ Search & Filters
  void applyFilters() {
    if (searchQuery.value.isEmpty) {
      filteredDisabilities.assignAll(disabilities);
    } else {
      filteredDisabilities.assignAll(disabilities.where((disability) =>
          disability["name"].toLowerCase().contains(searchQuery.value.toLowerCase())).toList());
    }
  }

  // ✅ Delete Disability
  Future<void> deleteDisability(String disabilityId) async {
    await _firestore.collection('disabilities').doc(disabilityId).delete();
    await fetchDisabilitiesWithTypeCount();
  }

  // ✅ Update Disability
  Future<void> updateDisability(String disabilityId, String name) async {
    try {
      await _firestore.collection('disabilities').doc(disabilityId).update({
        "name": name,
      });
      await fetchDisabilitiesWithTypeCount();
    } catch (e) {
      print("Error updating disability: $e");
    }
  }
}
