import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class AiCoachPage extends ConsumerStatefulWidget {
  const AiCoachPage({super.key});

  @override
  ConsumerState<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends ConsumerState<AiCoachPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading from Cloud Functions
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('AI Coach Insight', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation placeholder
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.neonPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.neonPurple),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Menganalisis pola latihanmu...',
            style: TextStyle(color: AppColors.neonPurple, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Menghubungkan ke Athlix AI Engine',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disclaimer (Mandatory per PRD)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'DISCLAIMER: Ini bukan saran medis profesional. Konsultasikan dengan dokter jika diperlukan.',
                    style: TextStyle(color: AppColors.warning.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Weekly Review Card
          _buildInsightCard(
            title: 'Review Latihan Mingguan',
            icon: Icons.auto_graph_rounded,
            color: AppColors.neonPurple,
            content: 'Minggu ini intensitas latihanmu meningkat 20%. Namun, distribusi harinya kurang merata. Cobalah untuk memberikan jeda 1 hari istirahat aktif (Recovery Run) setelah latihan intensitas tinggi (Endurance 10K).',
            actionText: 'Lihat Detail Latihan',
          ),
          const SizedBox(height: 16),

          // Injury Pattern Card
          _buildInsightCard(
            title: 'Analisis Risiko Cedera',
            icon: Icons.health_and_safety_rounded,
            color: AppColors.neonPink,
            content: 'Kamu mencatat "Nyeri lutut kanan" pada latihan Badminton terakhir. Mengingat kamu baru membuka skill "Smash" dan sering berlatih loncatan, perhatikan pendaratanmu. Kurangi intensitas hingga nyeri hilang.',
            actionText: 'Rekomendasi Pemanasan Lutut',
          ),
          const SizedBox(height: 16),

          // Partner Suggestion
          _buildInsightCard(
            title: 'Rekomendasi Partner',
            icon: Icons.people_alt_rounded,
            color: AppColors.neonBlue,
            content: 'Terdapat 3 pemain Badminton dengan Skill Level (Menengah) yang sering bermain di area Jakarta Selatan. Ingin mengadakan Open Match dengan mereka?',
            actionText: 'Buat Match Undangan',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    required String actionText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 13),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color.withValues(alpha: 0.5)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(actionText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
