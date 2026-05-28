import 'package:equatable/equatable.dart';

class TrainingSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String sportType;
  final DateTime date;
  final int durationMinutes;
  final String intensity; // 'Rendah', 'Sedang', 'Tinggi'
  final List<String> practicedSkills; // List of skill node IDs practiced
  final String? physicalComplaint; // Optional injury log
  final String? notes;

  const TrainingSessionEntity({
    required this.id,
    required this.userId,
    required this.sportType,
    required this.date,
    required this.durationMinutes,
    required this.intensity,
    required this.practicedSkills,
    this.physicalComplaint,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id, userId, sportType, date, durationMinutes, intensity, practicedSkills, physicalComplaint, notes
  ];
}
