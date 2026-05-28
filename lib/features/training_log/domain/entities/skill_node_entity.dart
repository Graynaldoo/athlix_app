import 'package:equatable/equatable.dart';

enum SkillStatus { locked, inProgress, mastered }

class SkillNodeEntity extends Equatable {
  final String id;
  final String name;
  final String sportType; // 'badminton' or 'lari'
  final String description;
  final int requiredXp;
  final int currentXp;
  final SkillStatus status;
  final List<String> prerequisiteIds; // IDs of skills needed before unlocking this
  final double posX; // For positioning in the CustomPainter
  final double posY;

  const SkillNodeEntity({
    required this.id,
    required this.name,
    required this.sportType,
    required this.description,
    required this.requiredXp,
    required this.currentXp,
    required this.status,
    required this.prerequisiteIds,
    required this.posX,
    required this.posY,
  });

  bool get isUnlocked => status != SkillStatus.locked;
  double get progress => (currentXp / requiredXp).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
    id, name, sportType, description, requiredXp, currentXp, status, prerequisiteIds, posX, posY,
  ];
}
