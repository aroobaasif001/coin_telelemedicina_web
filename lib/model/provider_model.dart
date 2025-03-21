import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderModel {
   String docId;
  String email;
  String fullName;
  String biography;
  String education;
  int experience;
  String healthCenterId;
  bool isVerified;
  List<String> languages;
  List<String> selectedServices;
  String photoUrl;
  double rating;
  int reviewCount;
  String specialty;
  DateTime createdAt;
  DateTime updatedAt;

  ProviderModel({
      required this.docId,
    required this.email,
    required this.fullName,
    required this.biography,
    required this.education,
    required this.experience,
    required this.healthCenterId,
    required this.isVerified,
    required this.languages,
    required this.selectedServices,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.specialty,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
       'docId': docId, 
      'email': email, 
      'fullName': fullName,
      'biography': biography,
      'education': education,
      'experience': experience,
      'healthCenterId': healthCenterId,
      'isVerified': isVerified,
      'languages': languages,
      'selectedServices': selectedServices,
      'photoUrl': photoUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'specialty': specialty,
       'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
       docId: map['docId'] ?? '', 
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      biography: map['biography'] ?? '',
      education: map['education'] ?? '',
      experience: map['experience'] ?? 0,
      healthCenterId: map['healthCenterId'] ?? '',
      isVerified: map['isVerified'] ?? false,
      languages: List<String>.from(map['languages'] ?? []),
      selectedServices: List<String>.from(map['selectedServices'] ?? []),
      photoUrl: map['photoUrl'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      specialty: map['specialty'] ?? '',
       createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(), 
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
