import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/skill_node_entity.dart';

class SkillTreePage extends StatefulWidget {
  const SkillTreePage({super.key});

  @override
  State<SkillTreePage> createState() => _SkillTreePageState();
}

class _SkillTreePageState extends State<SkillTreePage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _revealAnim;

  // Static seed data for Phase 1: Badminton Skills
  final List<SkillNodeEntity> _badmintonNodes = const [
    SkillNodeEntity(
      id: 'b1', name: 'Servis Pendek', sportType: 'badminton', description: 'Teknik dasar servis untuk ganda', 
      requiredXp: 100, currentXp: 100, status: SkillStatus.mastered, prerequisiteIds: [], posX: 0.5, posY: 0.1,
    ),
    SkillNodeEntity(
      id: 'b2', name: 'Servis Panjang', sportType: 'badminton', description: 'Teknik servis untuk tunggal', 
      requiredXp: 100, currentXp: 40, status: SkillStatus.inProgress, prerequisiteIds: ['b1'], posX: 0.3, posY: 0.3,
    ),
    SkillNodeEntity(
      id: 'b3', name: 'Footwork', sportType: 'badminton', description: 'Langkah kaki dasar di lapangan', 
      requiredXp: 200, currentXp: 0, status: SkillStatus.locked, prerequisiteIds: ['b1'], posX: 0.7, posY: 0.3,
    ),
    SkillNodeEntity(
      id: 'b4', name: 'Clear', sportType: 'badminton', description: 'Pukulan lob melambung ke belakang', 
      requiredXp: 300, currentXp: 0, status: SkillStatus.locked, prerequisiteIds: ['b2', 'b3'], posX: 0.5, posY: 0.5,
    ),
    SkillNodeEntity(
      id: 'b5', name: 'Drop Shot', sportType: 'badminton', description: 'Pukulan memotong di depan net', 
      requiredXp: 300, currentXp: 0, status: SkillStatus.locked, prerequisiteIds: ['b4'], posX: 0.3, posY: 0.7,
    ),
    SkillNodeEntity(
      id: 'b6', name: 'Smash', sportType: 'badminton', description: 'Pukulan menyerang menukik tajam', 
      requiredXp: 500, currentXp: 0, status: SkillStatus.locked, prerequisiteIds: ['b4'], posX: 0.7, posY: 0.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _revealAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showNodeDetail(SkillNodeEntity node) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgElevated,
      isScrollControlled: true,
      builder: (ctx) => _buildNodeDetailSheet(node),
    );
  }

  Widget _buildNodeDetailSheet(SkillNodeEntity node) {
    Color getStatusColor() {
      switch (node.status) {
        case SkillStatus.mastered: return AppColors.neonGold;
        case SkillStatus.inProgress: return AppColors.neonPurple;
        case SkillStatus.locked: return AppColors.textTertiary;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: getStatusColor().withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, color: getStatusColor(), size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(node.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      node.status == SkillStatus.locked ? 'Terkunci' : (node.status == SkillStatus.mastered ? 'Dikuasai' : 'Dalam Proses'),
                      style: TextStyle(color: getStatusColor(), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(node.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 24),
          
          if (node.status != SkillStatus.locked) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress XP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('${node.currentXp} / ${node.requiredXp} XP', style: const TextStyle(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: node.progress,
              backgroundColor: AppColors.bgTertiary,
              color: getStatusColor(),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
          
          if (node.status == SkillStatus.locked) ...[
            const Text('Syarat Membuka:', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            // Just placeholder text for requirements
            const Text('• Selesaikan skill sebelumnya', style: TextStyle(color: AppColors.textTertiary)),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Skill Tree', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.info_outline_rounded, color: AppColors.textTertiary), onPressed: () {}),
        ],
      ),
      body: ScaleTransition(
        scale: _revealAnim,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _SkillTreePainter(_badmintonNodes),
              child: Stack(
                children: _badmintonNodes.map((node) {
                  final x = node.posX * constraints.maxWidth;
                  final y = node.posY * constraints.maxHeight;
                  return Positioned(
                    left: x - 40, // 40 is half of the node width
                    top: y - 40,
                    child: GestureDetector(
                      onTap: () => _showNodeDetail(node),
                      child: _SkillNodeWidget(node: node),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkillNodeWidget extends StatelessWidget {
  final SkillNodeEntity node;
  const _SkillNodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color glowColor;
    
    switch (node.status) {
      case SkillStatus.mastered:
        borderColor = AppColors.neonGold;
        glowColor = AppColors.neonGold.withValues(alpha: 0.5);
        break;
      case SkillStatus.inProgress:
        borderColor = AppColors.neonPurple;
        glowColor = AppColors.neonPurple.withValues(alpha: 0.4);
        break;
      case SkillStatus.locked:
        borderColor = AppColors.textTertiary.withValues(alpha: 0.5);
        glowColor = Colors.transparent;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgSecondary,
            border: Border.all(color: borderColor, width: node.status == SkillStatus.mastered ? 3 : 2),
            boxShadow: glowColor != Colors.transparent ? [
              BoxShadow(color: glowColor, blurRadius: 16),
            ] : null,
          ),
          child: Center(
            child: Icon(
              node.status == SkillStatus.locked ? Icons.lock_rounded : Icons.star_rounded,
              color: node.status == SkillStatus.locked ? AppColors.textTertiary : borderColor,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          node.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: node.status == SkillStatus.locked ? AppColors.textTertiary : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SkillTreePainter extends CustomPainter {
  final List<SkillNodeEntity> nodes;
  _SkillTreePainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = AppColors.neonPurple.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var node in nodes) {
      if (node.prerequisiteIds.isEmpty) continue;

      for (var reqId in node.prerequisiteIds) {
        final parent = nodes.firstWhere((n) => n.id == reqId);
        
        final startX = parent.posX * size.width;
        final startY = parent.posY * size.height;
        final endX = node.posX * size.width;
        final endY = node.posY * size.height;

        final path = Path()
          ..moveTo(startX, startY)
          ..lineTo(endX, endY);

        // Draw active line if both are unlocked/progressing
        if (parent.isUnlocked && node.isUnlocked) {
          canvas.drawPath(path, activePaint);
        } else {
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
