import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:coin_telelemedicina_web/model/health_center_model.dart';

class HealthCenterController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  RxList<String> provinceList = <String>[].obs;
  RxList<String> municipalityList = <String>[].obs;
  RxList<String> sectorList = <String>[].obs;

  RxString selectedProvince = ''.obs;
  RxString selectedMunicipality = ''.obs;
  RxString selectedSector = ''.obs;

  RxBool isLoading = false.obs;
  var healthCenters = <HealthCenterModel>[].obs;

  @override
  void onInit() {
    fetchProvinces();
    fetchHealthCenters();
    super.onInit();
  }

  Future<void> fetchProvinces() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await _firestore.collection("provinces").get();
      provinceList.value = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching provinces: $e");
      Get.snackbar('Error', 'Failed to load provinces');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMunicipalities(String province) async {
    try {
      isLoading(true);
      selectedProvince.value = province;
      selectedMunicipality.value = '';
      selectedSector.value = '';
      municipalityList.clear();
      sectorList.clear();

      QuerySnapshot snapshot = await _firestore
          .collection("provinces")
          .doc(province)
          .collection("municipalities")
          .get();

      municipalityList.value = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching municipalities: $e");
      Get.snackbar('Error', 'Failed to load municipalities');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSectors(String municipality) async {
    try {
      isLoading(true);
      selectedMunicipality.value = municipality;
      selectedSector.value = '';
      sectorList.clear();

      QuerySnapshot snapshot = await _firestore
          .collection("provinces")
          .doc(selectedProvince.value)
          .collection("municipalities")
          .doc(municipality)
          .collection("sectors")
          .get();

      sectorList.value = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching sectors: $e");
      Get.snackbar('Error', 'Failed to load sectors');
    } finally {
      isLoading(false);
    }
  }

  void fetchHealthCenters() {
    _firestore.collection('healthCenters').snapshots().listen((snapshot) {
      healthCenters.value = snapshot.docs.map((doc) {
        return HealthCenterModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}


///


// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coin_telelemedicina_web/model/health_center_model.dart';
//
// class HealthCenterController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   var healthCenters = <HealthCenterModel>[].obs;
//   var isLoading = true.obs;
//   RxList<String> provinceList = <String>[].obs;
//   RxMap<String, List<String>> municipalityMap = <String, List<String>>{}.obs;
//   RxMap<String, List<String>> sectorMap = <String, List<String>>{}.obs;
//
//   RxString selectedProvince = RxString("");
//   RxString selectedMunicipality = RxString("");
//   RxString selectedSector = RxString("");
//
//   @override
//   void onInit() {
//     fetchProvinces();
//     fetchHealthCenters();
//     super.onInit();
//   }
//
//   void fetchHealthCenters() {
//     _firestore.collection('healthCenters').snapshots().listen((snapshot) {
//       healthCenters.value = snapshot.docs.map((doc) {
//         return HealthCenterModel.fromMap(
//             doc.data() as Map<String, dynamic>, doc.id);
//       }).toList();
//       isLoading(false);
//     });
//   }
//
//   Future<void> fetchProvinces() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection("provinces").get();
//       provinceList.value = snapshot.docs.map((doc) => doc.id).toList();
//     } catch (e) {
//       print("Error fetching provinces: $e");
//     }
//   }
//
//   Future<void> fetchMunicipalities(String province) async {
//     selectedProvince.value = province;
//     selectedMunicipality.value = "";
//     selectedSector.value = "";
//     municipalityMap.clear();
//
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection("provinces")
//           .doc(province)
//           .collection("municipalities")
//           .get();
//
//       List<String> municipalities = snapshot.docs.map((doc) => doc.id).toList();
//       municipalityMap[province] = municipalities;
//     } catch (e) {
//       print("Error fetching municipalities: $e");
//     }
//   }
//
//   Future<void> fetchSectors(String municipality) async {
//     selectedMunicipality.value = municipality;
//     selectedSector.value = "";
//     sectorMap.clear();
//
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection("provinces")
//           .doc(selectedProvince.value)
//           .collection("municipalities")
//           .doc(municipality)
//           .collection("sectors")
//           .get();
//
//       List<String> sectors = snapshot.docs.map((doc) => doc.id).toList();
//       sectorMap[municipality] = sectors;
//     } catch (e) {
//       print("Error fetching sectors: $e");
//     }
//   }
// }
