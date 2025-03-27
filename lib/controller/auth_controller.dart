import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/view/screens/dashboardScreen/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/provider_model.dart';
import '../model/patient_model.dart';
import '../view/screens/patient/add_patient_screen.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _storage = GetStorage();

  final RxBool isLoggedIn = false.obs;
  final Rx<Map<String, dynamic>?> currentAdmin = Rx<Map<String, dynamic>?>(null);

  var existingImageUrl = ''.obs;
  var existingProviderImageUrl = ''.obs;
  var isLoading = false.obs;
  var profileImage = Rx<File?>(null);
  var userProfile = Rxn<PatientModel>();
  var userProviderProfile = Rxn<ProviderModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProviderProfile();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final adminData = _storage.read('admin_data');
    if (adminData != null) {
      currentAdmin.value = Map<String, dynamic>.from(adminData);
      isLoggedIn.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final adminDoc = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (adminDoc.docs.isNotEmpty) {
        final adminData = adminDoc.docs.first.data();
        currentAdmin.value = adminData;
        _storage.write('admin_data', adminData);
        isLoggedIn.value = true;
        return true;
      }
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  void logout() {
    _storage.remove('admin_data');
    currentAdmin.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  // Getter para obtener información del admin actual
  String get adminName => currentAdmin.value?['name'] ?? '';
  String get adminEmail => currentAdmin.value?['email'] ?? '';

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<String?> uploadProfileImage(String userId) async {
    if (profileImage.value == null) return null;
    try {
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      await ref.putFile(profileImage.value!);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      isLoading(true);
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        Get.to(() => PatientRegistrationScreen());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> completeProfile(PatientModel profile) async {
    try {
      User? user = _auth.currentUser;
      String? imageUrl = await uploadProfileImage(user!.uid);
      profile.profileImage = imageUrl;
      profile.email = user.email ?? '';

      await _firestore.collection("patients").doc(user.uid).set(profile.toMap());
      Get.snackbar("Success", "Profile Completed", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('patients').doc(user.uid).get();
      if (snapshot.exists) {
        userProfile.value = PatientModel.fromMap(snapshot.data() as Map<String, dynamic>);
        existingImageUrl.value = userProfile.value?.profileImage ?? '';
      }
    }
  }

  Future<void> fetchProviderProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('providers').doc(user.uid).get();
      if (snapshot.exists) {
        userProviderProfile.value = ProviderModel.fromMap(snapshot.data() as Map<String, dynamic>);
        existingProviderImageUrl.value = userProfile.value?.profileImage ?? '';
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading(true);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        Get.offAll(() => PatientRegistrationScreen());
      } else {
        Get.offAll(() => DashboardScreen());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadExistingProfileImage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('patients').doc(user.uid).get();
      if (snapshot.exists && snapshot['profileImage'] != null) {
        existingImageUrl.value = snapshot['profileImage'];
      }
    }
  }

  Future<void> loadExistingProviderProfileImage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('providers').doc(user.uid).get();
      if (snapshot.exists && snapshot['photoUrl'] != null) {
        existingImageUrl.value = snapshot['photoUrl'];
      }
    }
  }
}
}