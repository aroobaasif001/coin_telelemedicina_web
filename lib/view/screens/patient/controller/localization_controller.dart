import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<String> provinceList = <String>[].obs;
  RxMap<String, List<String>> municipalityMap = <String, List<String>>{}.obs;
  RxMap<String, List<String>> sectorMap = <String, List<String>>{}.obs;

  RxString selectedProvince = RxString("");
  RxString selectedMunicipality = RxString("");
  RxString selectedSector = RxString("");

  @override
  void onInit() {
    fetchProvinces();
    super.onInit();
  }

  Future<void> fetchProvinces() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("provinces").get();
      provinceList.value = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching provinces: $e");
    }
  }

  Future<void> fetchMunicipalities(String province) async {
    selectedProvince.value = province;
    selectedMunicipality.value = "";
    selectedSector.value = "";
    municipalityMap.clear();

    try {
      QuerySnapshot snapshot = await firestore
          .collection("provinces")
          .doc(province)
          .collection("municipalities")
          .get();

      List<String> municipalities = snapshot.docs.map((doc) => doc.id).toList();
      municipalityMap[province] = municipalities;
    } catch (e) {
      print("Error fetching municipalities: $e");
    }
  }

  Future<void> fetchSectors(String municipality) async {
    selectedMunicipality.value = municipality;
    selectedSector.value = "";
    sectorMap.clear();

    try {
      QuerySnapshot snapshot = await firestore
          .collection("provinces")
          .doc(selectedProvince.value)
          .collection("municipalities")
          .doc(municipality)
          .collection("sectors")
          .get();

      List<String> sectors = snapshot.docs.map((doc) => doc.id).toList();
      sectorMap[municipality] = sectors;
    } catch (e) {
      print("Error fetching sectors: $e");
    }
  }
}
