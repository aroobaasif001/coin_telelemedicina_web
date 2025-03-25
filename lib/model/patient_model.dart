import 'package:cloud_firestore/cloud_firestore.dart';
class PatientModel {
  String fullName;
  String dob;
  String phoneNumber;
  String id;
  String state;
  String municipality;
  String address;
  String gender;
  String disability;
  String disabilityType;
  String email;
  String documentId;
  String fcmToken;
  String? profileImage;
  String? provincia;
  String? sector;
  String? status;
  bool hasDisability;
  bool isOnline;
  bool isProfileComplete;
  String? lastSignOut;
  String? lastTokenUpdate;
  String? role;
  String? uid;
  DateTime? updatedAt;
  String? callingChannelId;

  List<String>? cedulaImages; // List of uploaded Cedula (ID) images
  List<String>? insuranceImages;

  PatientModel({
    required this.fullName,
    required this.dob,
    required this.phoneNumber,
    required this.id,
    required this.state,
    required this.municipality,
    required this.address,
    required this.gender,
    required this.disability,
    required this.disabilityType,
    required this.email,
    required this.documentId,
    required this.fcmToken,
    this.profileImage,
    required this.provincia,
    required this.sector,
    this.callingChannelId,
    this.status,
    required this.hasDisability,
    required this.isOnline,
    required this.isProfileComplete,
    this.lastSignOut,
    this.lastTokenUpdate,
    this.role,
    this.uid,
    this.updatedAt,
    this.cedulaImages,
    this.insuranceImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'dob': dob,
      'phoneNumber': phoneNumber,
      'id': id,
      'state': state,
      'municipality': municipality,
      'address': address,
      'gender': gender,
      'disability': disability,
      'disabilityType': disabilityType,
      'email': email,
      'documentId': documentId,
      'fcmToken': fcmToken,
      'profileImage': profileImage,
      'provincia': provincia,
      'sector': sector,
      'status': status,
      'callingChannelId':callingChannelId,
      'hasDisability': hasDisability,
      'isOnline': isOnline,
      'isProfileComplete': isProfileComplete,
      'lastSignOut': lastSignOut,
      'lastTokenUpdate': lastTokenUpdate,
      'role': role,
      'uid': uid,
      'updatedAt': updatedAt,
      'regDate': FieldValue.serverTimestamp(),
      'cedulaImages': cedulaImages ?? [],
      'insuranceImages': insuranceImages ?? [],
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      fullName: map['fullName'],
      dob: map['dob'],
      phoneNumber: map['phoneNumber'],
      id: map['id'],
      state: map['state'],
      municipality: map['municipality'],
      address: map['address'],
      gender: map['gender'],
      disability: map['disability'],
      disabilityType: map['disabilityType'],
      email: map['email'],
      documentId: map['documentId'],
      fcmToken: map['fcmToken'],
      profileImage: map['profileImage'],
      provincia: map['provincia'],
      sector: map['sector'],
      status: map['status'],
      callingChannelId: map['callingChannelId'],
      hasDisability: map['hasDisability'],
      isOnline: map['isOnline'],
      isProfileComplete: map['isProfileComplete'],
      lastSignOut: map['lastSignOut'],
      lastTokenUpdate: map['lastTokenUpdate'],
      role: map['role'],
      uid: map['uid'],
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      cedulaImages: List<String>.from(map['cedulaImages'] ?? []),
      insuranceImages: List<String>.from(map['insuranceImages'] ?? []),
    );
  }
}