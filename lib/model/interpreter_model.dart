import 'package:cloud_firestore/cloud_firestore.dart';

class InterpreterModel {
  String fullName;
  String biography;
  String education;
  int experience;
  String healthCenterId;
  List<String> interpreterTypes;
  List<String> languages;
  String photoUrl;
  bool isVerified;
  double rating;
  int totalRatings;
  DateTime createdAt;
  DateTime updatedAt;

  InterpreterModel({
    required this.fullName,
    required this.biography,
    required this.education,
    required this.experience,
    required this.healthCenterId,
    required this.interpreterTypes,
    required this.languages,
    required this.photoUrl,
    required this.isVerified,
    required this.rating,
    required this.totalRatings,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'biography': biography,
      'education': education,
      'experience': experience,
      'healthCenterId': healthCenterId,
      'interpreterTypes': interpreterTypes,
      'languages': languages,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
      'rating': rating,
      'totalRatings': totalRatings,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory InterpreterModel.fromMap(Map<String, dynamic> map) {
    return InterpreterModel(
      fullName: map['fullName'],
      biography: map['biography'],
      education: map['education'],
      experience: map['experience'],
      healthCenterId: map['healthCenterId'],
      interpreterTypes: List<String>.from(map['interpreterTypes']),
      languages: List<String>.from(map['languages']),
      photoUrl: map['photoUrl'],
      isVerified: map['isVerified'],
      rating: map['rating'],
      totalRatings: map['totalRatings'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
