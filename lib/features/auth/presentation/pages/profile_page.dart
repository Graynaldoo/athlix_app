import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: authState.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Tidak ada data user'));
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, user.name, user.email, user.reliabilityScore, user.createdAt),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      _buildStatRow(user.reliabilityScore),
                      const SizedBox(height: 32),
                      _menuItem(context, Icons.person_outline_rounded, 'Edit Profil', 'Ubah nama dan foto profil', AppColors.neonBlue, () {}),
                      _menuItem(context, Icons.history_rounded, 'Riwayat Aktivitas', 'Lihat semua aktivitas', AppColors.neonPurple, () {}),
                      _menuItem(context, Icons.bar_chart_rounded, 'Statistik', 'Analisis performa olahraga', AppColors.neonGreen, () {}),
                      _menuItem(context, Icons.settings_outlined, 'Pengaturan', 'Notifikasi, tema, bahasa', AppColors.textSecondary, () {}),
                      _menuItem(context, Icons.help_outline_rounded, 'Bantuan', 'FAQ dan hubungi kami', AppColors.textSecondary, () {}),
                      const SizedBox(height: 24),
                      _logoutButton(context, ref),
                      const SizedBox(height: 120), // padding for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(child: Text('Gagal memuat profil', style: TextStyle(color: AppColors.error))),
      ),
    );
  }

  Widget _buildAppBar(BuildContext ctx, String name, String email, double score, DateTime createdAt) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.bgPrimary,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(name, style: Theme.of(ctx).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(email, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgTertiary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text(
                  'Anggota sejak ${DateFormat('MMM yyyy', 'id').format(createdAt)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      title: const Text('Profil'),
    );
  }

  Widget _buildStatRow(double score) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              _profileStat('0', 'Latihan', AppColors.neonPurple),
              _divider(),
              _profileStat('0', 'Match', AppColors.neonBlue),
              _divider(),
              _profileStat('${score.toInt()}%', 'Reliabilitas', AppColors.reliabilityColor(score)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1));
  }

  Widget _menuItem(BuildContext ctx, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context, ref),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonPink,
          side: const BorderSide(color: AppColors.neonPink),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('Keluar dari Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: const Text('Keluar?'),
        content: const Text('Yakin ingin keluar dari akun Athlix? Anda harus login kembali untuk mencatat latihan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authNotifierProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonPink),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
