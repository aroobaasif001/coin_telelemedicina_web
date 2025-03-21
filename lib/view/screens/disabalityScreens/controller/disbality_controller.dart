// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DisabilityController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   var disabilities = <Map<String, dynamic>>[].obs;
//   var searchQuery = ''.obs;
//   var selectedDisabilityFilter = ''.obs;
//   var selectedTypeFilter = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchDisabilities();
//   }
//
//   // Fetch Disabilities from Firestore
//   Future<void> fetchDisabilities() async {
//     try {
//       var snapshot = await _firestore.collection('disabilities').get();
//       disabilities.value = snapshot.docs.map((doc) => {
//             "id": doc.id,
//             "name": doc["name"],
//             "types": 0, // Default count
//           }).toList();
//
//       // Fetch the number of types for each disability
//       for (var disability in disabilities) {
//         var typesSnapshot = await _firestore
//             .collection('disabilityTypes')
//             .where('disabilityId', isEqualTo: disability["id"])
//             .get();
//         disability["types"] = typesSnapshot.docs.length;
//       }
//
//       update();
//     } catch (e) {
//       print("Error fetching disabilities: $e");
//     }
//   }
//
//   // Filter Disabilities
//   List<Map<String, dynamic>> get filteredDisabilities {
//     if (searchQuery.value.isEmpty) {
//       return disabilities;
//     }
//     return disabilities
//         .where((disability) =>
//             disability["name"].toLowerCase().contains(searchQuery.value.toLowerCase()))
//         .toList();
//   }
//
//   // Delete Disability
//   Future<void> deleteDisability(String disabilityId) async {
//     await _firestore.collection('disabilities').doc(disabilityId).delete();
//     fetchDisabilities();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DisabilityController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var disabilities = <Map<String, dynamic>>[].obs;
  var types = <Map<String, dynamic>>[].obs; // ✅ Add this to store types

  var searchQuery = ''.obs;
  var selectedDisabilityFilter = ''.obs;
  var selectedTypeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisabilities();
    fetchDisabilityTypes(); // ✅ Fetch types when initialized
  }

  // Fetch Disabilities from Firestore
  Future<void> fetchDisabilities() async {
    try {
      var snapshot = await _firestore.collection('disabilities').get();
      disabilities.value = snapshot.docs.map((doc) => {
        "id": doc.id,
        "name": doc["name"],
        "types": 0, // Default count
      }).toList();

      // Count types per disability
      for (var disability in disabilities) {
        var typesSnapshot = await _firestore
            .collection('disabilityTypes')
            .where('disabilityId', isEqualTo: disability["id"])
            .get();
        disability["types"] = typesSnapshot.docs.length;
      }

      update();
    } catch (e) {
      print("Error fetching disabilities: $e");
    }
  }

  // ✅ Fetch Disability Types
  Future<void> fetchDisabilityTypes() async {
    try {
      var snapshot = await _firestore.collection('disabilityTypes').get();
      types.value = snapshot.docs.map((doc) => {
        "id": doc.id,
        "name": doc["name"],
      }).toList();
      update();
    } catch (e) {
      print("Error fetching types: $e");
    }
  }

  // Filter Disabilities
  List<Map<String, dynamic>> get filteredDisabilities {
    if (searchQuery.value.isEmpty) {
      return disabilities;
    }
    return disabilities
        .where((disability) =>
        disability["name"].toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Delete Disability
  Future<void> deleteDisability(String disabilityId) async {
    await _firestore.collection('disabilities').doc(disabilityId).delete();
    fetchDisabilities();
  }
}

