import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: authState.when(
        data: (user) {
          final userName = user?.name ?? 'Atlet';
          final score = user?.reliabilityScore ?? 100.0;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.surface,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context, userName),
                ),
                title: const Text('Athlix'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildStats(score))),
              SliverToBoxAdapter(child: _buildFeatures(context)),
              SliverToBoxAdapter(child: _buildActivityHeader(context)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(delegate: SliverChildListDelegate([
                  _activityTile(Icons.fitness_center_rounded, AppColors.sportRunning, 'Mulai catat latihanmu!', 'Tambah latihan pertamamu', 'Sekarang'),
                  _activityTile(Icons.sports_soccer_rounded, AppColors.sportFootball, 'Cari lawan tanding', 'Jelajahi open match terdekat', 'Baru'),
                  _activityTile(Icons.emoji_events_rounded, AppColors.accent, 'Skor Reliabilitas 100%', 'Pertahankan reputasimu!', 'Info'),
                ])),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat data')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
              ),
              child: Center(child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Halo, $userName! 👋', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Siap berlatih hari ini?', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
            ])),
          ]),
        ],
      ),
    );
  }

  Widget _buildStats(double score) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          _statCard(Icons.fitness_center_rounded, '0', 'Latihan\nMinggu Ini', AppColors.sportRunning),
          _statCard(Icons.sports_soccer_rounded, '0', 'Match\nMendatang', AppColors.sportFootball),
          _statCard(Icons.star_rounded, '${score.toInt()}%', 'Skor\nReliabilitas', AppColors.accent),
        ]),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 22)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
      ]),
    ));
  }

  Widget _buildFeatures(BuildContext context) {
    final items = [
      [Icons.fitness_center_rounded, 'Log Latihan', const [Color(0xFF8B5CF6), Color(0xFFA78BFA)]],
      [Icons.sports_soccer_rounded, 'Open Match', const [Color(0xFF22C55E), Color(0xFF4ADE80)]],
      [Icons.location_on_rounded, 'Cari Venue', const [Color(0xFF3B82F6), Color(0xFF60A5FA)]],
      [Icons.smart_toy_rounded, 'AI Coach', const [Color(0xFFF59E0B), Color(0xFFFBBF24)]],
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fitur', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: items.map((item) {
          return GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item[1]} — Segera Hadir!'), behavior: SnackBarBehavior.floating)),
            child: Column(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(gradient: LinearGradient(colors: item[2] as List<Color>), borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: (item[2] as List<Color>)[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]),
                child: Icon(item[0] as IconData, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(item[1] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ]),
          );
        }).toList()),
      ]),
    );
  }

  Widget _buildActivityHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Aktivitas Terkini', style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
      ]),
    );
  }

  Widget _activityTile(IconData icon, Color color, String title, String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(8)),
          child: Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        ),
      ]),
    );
  }
}
