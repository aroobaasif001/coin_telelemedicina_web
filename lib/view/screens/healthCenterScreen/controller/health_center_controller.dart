import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/model/health_center_model.dart';

class HealthCenterController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var healthCenters = <HealthCenterModel>[].obs; 
  var isLoading = true.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchHealthCenters(); 
  }

  void fetchHealthCenters() {
    _firestore.collection('healthCenters').snapshots().listen((snapshot) {
      healthCenters.value = snapshot.docs.map((doc) {
        return HealthCenterModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      isLoading(false);
    });
  }
}
