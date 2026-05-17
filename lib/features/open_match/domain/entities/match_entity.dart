import 'package:equatable/equatable.dart';

enum SportType { badminton, lari }
enum MatchStatus { open, full, completed, cancelled }
enum SkillLevel { pemula, menengah, mahir }

class MatchEntity extends Equatable {
  final String id;
  final String hostId;
  final String hostName;
  final double hostReliabilityScore;
  final SportType sportType;
  final SkillLevel skillLevel;
  final String location;
  final DateTime matchDate;
  final String timeSlot;
  final int maxPlayers;
  final List<String> joinedPlayerIds;
  final MatchStatus status;
  final String? notes;
  final DateTime createdAt;

  const MatchEntity({
    required this.id,
    required this.hostId,
    required this.hostName,
    required this.hostReliabilityScore,
    required this.sportType,
    required this.skillLevel,
    required this.location,
    required this.matchDate,
    required this.timeSlot,
    required this.maxPlayers,
    required this.joinedPlayerIds,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  int get currentPlayers => joinedPlayerIds.length;
  bool get isFull => currentPlayers >= maxPlayers;
  bool get isOpen => status == MatchStatus.open && !isFull;

  @override
  List<Object?> get props => [id, hostId, status, joinedPlayerIds];
}