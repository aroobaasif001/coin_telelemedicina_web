import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';

class DoctorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var doctors = <ProviderModel>[].obs; 
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors(); 
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await _firestore.collection('providers').get();
      doctors.value = querySnapshot.docs.map((doc) {
        return ProviderModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching doctors: $e");
    } finally {
      isLoading(false);
    }
  }
}
