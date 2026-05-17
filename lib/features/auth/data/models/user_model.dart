import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    super.photoUrl,
    super.reliabilityScore,
    required super.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      reliabilityScore: (data['reliabilityScore'] ?? 100.0).toDouble(),
      createdAt: _parseDateTime(data['createdAt']),
    );
  }

  /// Safely parse createdAt which could be:
  /// - Firestore Timestamp
  /// - ISO 8601 String
  /// - null
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'reliabilityScore': reliabilityScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}