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
      backgroundColor: AppColors.surface,
      body: authState.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Tidak ada data user'));
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(context, user.name, user.email, user.reliabilityScore, user.createdAt),
                ),
                title: const Text('Profil', style: TextStyle(color: Colors.white)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    _buildStatRow(user.reliabilityScore),
                    const SizedBox(height: 24),
                    _menuItem(context, Icons.person_outline_rounded, 'Edit Profil', 'Ubah nama dan foto profil', () {}),
                    _menuItem(context, Icons.history_rounded, 'Riwayat Aktivitas', 'Lihat semua aktivitas', () {}),
                    _menuItem(context, Icons.bar_chart_rounded, 'Statistik', 'Analisis performa olahraga', () {}),
                    _menuItem(context, Icons.settings_outlined, 'Pengaturan', 'Notifikasi, tema, bahasa', () {}),
                    _menuItem(context, Icons.help_outline_rounded, 'Bantuan', 'FAQ dan hubungi kami', () {}),
                    const SizedBox(height: 16),
                    _logoutButton(context, ref),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat profil')),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext ctx, String name, String email, double score, DateTime createdAt) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
          ),
          child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700))),
        ),
        const SizedBox(height: 14),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
        const SizedBox(height: 6),
        Text('Anggota sejak ${DateFormat('MMMM yyyy', 'id').format(createdAt)}', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
      ]),
    );
  }

  Widget _buildStatRow(double score) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Row(children: [
        _profileStat('0', 'Latihan'),
        _divider(),
        _profileStat('0', 'Match'),
        _divider(),
        _profileStat('${score.toInt()}%', 'Reliabilitas'),
      ]),
    );
  }

  Widget _profileStat(String value, String label) {
    return Expanded(child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ]));
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: Colors.grey.shade200);
  }

  Widget _menuItem(BuildContext ctx, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
            ]),
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
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('Keluar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar?'),
        content: const Text('Yakin ingin keluar dari akun Athlix?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authNotifierProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
