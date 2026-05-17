import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/match_entity.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.id,
    required super.hostId,
    required super.hostName,
    required super.hostReliabilityScore,
    required super.sportType,
    required super.skillLevel,
    required super.location,
    required super.matchDate,
    required super.timeSlot,
    required super.maxPlayers,
    required super.joinedPlayerIds,
    required super.status,
    super.notes,
    required super.createdAt,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      id: doc.id,
      hostId: data['hostId'] ?? '',
      hostName: data['hostName'] ?? '',
      hostReliabilityScore: (data['hostReliabilityScore'] ?? 100.0).toDouble(),
      sportType: SportType.values.firstWhere(
            (e) => e.name == data['sportType'],
        orElse: () => SportType.badminton,
      ),
      skillLevel: SkillLevel.values.firstWhere(
            (e) => e.name == data['skillLevel'],
        orElse: () => SkillLevel.pemula,
      ),
      location: data['location'] ?? '',
      matchDate: (data['matchDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      maxPlayers: data['maxPlayers'] ?? 4,
      joinedPlayerIds: List<String>.from(data['joinedPlayerIds'] ?? []),
      status: MatchStatus.values.firstWhere(
            (e) => e.name == data['status'],
        orElse: () => MatchStatus.open,
      ),
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hostId': hostId,
      'hostName': hostName,
      'hostReliabilityScore': hostReliabilityScore,
      'sportType': sportType.name,
      'skillLevel': skillLevel.name,
      'location': location,
      'matchDate': Timestamp.fromDate(matchDate),
      'timeSlot': timeSlot,
      'maxPlayers': maxPlayers,
      'joinedPlayerIds': joinedPlayerIds,
      'status': status.name,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}