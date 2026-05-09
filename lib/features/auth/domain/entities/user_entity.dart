import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final double reliabilityScore;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    this.reliabilityScore = 100.0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, name, photoUrl];
}