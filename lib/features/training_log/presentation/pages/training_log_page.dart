import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import 'skill_tree_page.dart';
import 'add_session_page.dart';

class TrainingLogPage extends ConsumerWidget {
  const TrainingLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Log Latihan', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.bgPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Chart Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Intensitas Latihan Minggu Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: _buildWeeklyChart(),
                  ),
                ],
              ),
            ),

            // Skill Tree Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SkillTreePage()));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.aiGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_tree_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pohon Kemampuan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text('Lihat progres dan buka skill baru!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Recent Sessions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Riwayat Latihan Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  TextButton(onPressed: () {}, child: const Text('Lihat Semua', style: TextStyle(color: AppColors.primary))),
                ],
              ),
            ),
            
            // Dummy List (To be replaced with Provider data later)
            _buildSessionTile('Lari - Endurance 5K', 'Intensitas: Tinggi', 'Hari ini, 06:00', AppColors.sportRunning, Icons.directions_run_rounded),
            _buildSessionTile('Badminton - Footwork', 'Intensitas: Sedang', 'Kemarin, 19:00', AppColors.neonBlue, Icons.sports_tennis_rounded),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSessionPage()));
          },
          backgroundColor: AppColors.neonPurple,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('Catat Latihan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(days[value.toInt()], style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                );
              },
            ),
          ),
        ),
        barGroups: [
          _makeGroupData(0, 40, AppColors.neonBlue),
          _makeGroupData(1, 0, AppColors.textTertiary),
          _makeGroupData(2, 60, AppColors.neonPurple),
          _makeGroupData(3, 30, AppColors.neonBlue),
          _makeGroupData(4, 0, AppColors.textTertiary),
          _makeGroupData(5, 80, AppColors.primary),
          _makeGroupData(6, 0, AppColors.textTertiary),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTile(String title, String subtitle, String time, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
