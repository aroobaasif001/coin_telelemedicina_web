import 'package:cloud_firestore/cloud_firestore.dart';

class HealthCenterModel {
  String id;
  String name;
  String address;
  String city;
  String municipality;
  String province;
  String phone;
  String email;
  String website;
  String description;
  String sector;
  List<String> services;
  bool isActive;
  double latitude;
  double longitude;
  Map<String, Map<String, String>> availability;
  DateTime createdAt;
  DateTime updatedAt;

  HealthCenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.municipality,
    required this.province,
    required this.phone,
    required this.email,
    required this.website,
    required this.description,
    required this.sector,
    required this.services,
    required this.isActive,
    required this.latitude,
    required this.longitude,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts Firestore document to `HealthCenterModel`
  factory HealthCenterModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HealthCenterModel(
      id: documentId,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      municipality: map['municipality'] ?? '',
      province: map['province'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      description: map['description'] ?? '',
      sector: map['sector'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      isActive: map['isActive'] ?? false,
      latitude: (map['coordinates'] != null && map['coordinates']['latitude'] != null)
          ? (map['coordinates']['latitude'] as num).toDouble()
          : 0.0,
      longitude: (map['coordinates'] != null && map['coordinates']['longitude'] != null)
          ? (map['coordinates']['longitude'] as num).toDouble()
          : 0.0,
      availability: (map['availability'] as Map<String, dynamic>?)?.map((key, value) {
            return MapEntry(key, {
              'open': value['open'] ?? '',
              'close': value['close'] ?? '',
            });
          }) ??
          {
            'monday': {'open': '', 'close': ''},
            'tuesday': {'open': '', 'close': ''},
            'wednesday': {'open': '', 'close': ''},
            'thursday': {'open': '', 'close': ''},
            'friday': {'open': '', 'close': ''},
            'saturday': {'open': '', 'close': ''},
            'sunday': {'open': '', 'close': ''},
          },
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts `HealthCenterModel` to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'municipality': municipality,
      'province': province,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'sector': sector,
      'services': services,
      'isActive': isActive,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'availability': availability.map((key, value) {
        return MapEntry(key, {
          'open': value['open'] ?? '',
          'close': value['close'] ?? '',
        });
      }),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
