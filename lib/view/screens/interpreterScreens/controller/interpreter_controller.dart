import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/model/interpreter_model.dart';

class InterpreterController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var interpreters = <InterpreterModel>[].obs; // List of interpreters
  var isLoading = true.obs; // Loading state

  @override
  void onInit() {
    super.onInit();
    fetchInterpreters(); // Load interpreters on startup
  }

  Future<void> fetchInterpreters() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await _firestore.collection('interpreterProfiles').get();
      interpreters.value = querySnapshot.docs.map((doc) {
        return InterpreterModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching interpreters: $e");
    } finally {
      isLoading(false);
    }
  }
}
