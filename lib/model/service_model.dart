import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String id;
  String name;
  String description;
  int duration;
  String icon;
  int price;
  bool requiresInterpreter;
  List<String> supportedInterpreterTypes;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.icon,
    required this.price,
    required this.requiresInterpreter,
    required this.supportedInterpreterTypes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'icon': icon,
      'price': price,
      'requiresInterpreter': requiresInterpreter,
      'supportedInterpreterTypes': supportedInterpreterTypes,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      duration: map['duration'] ?? 0,
      icon: map['icon'] ?? '',
      price: map['price'] ?? 0,
      requiresInterpreter: map['requiresInterpreter'] ?? false,
      supportedInterpreterTypes: List<String>.from(map['supportedInterpreterTypes'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
