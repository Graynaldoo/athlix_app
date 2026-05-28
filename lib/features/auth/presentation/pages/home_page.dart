import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../ai_coach/presentation/pages/ai_coach_page.dart';
import '../../../open_match/presentation/pages/open_match_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: authState.when(
        data: (user) {
          final userName = user?.name ?? 'Athlete';
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.bgPrimary,
                surfaceTintColor: Colors.transparent,
                title: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: AppColors.heroGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.neonPink,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Stats Row ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          _statCard('1,240', 'kcal burned',
                              AppColors.neonGold, Icons.local_fire_department_rounded),
                          const SizedBox(width: 12),
                          _statCard('88%', 'Quality Rest',
                              AppColors.neonGreen, Icons.nightlight_round),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _metricTile('HYDRATION', '75%', '2.4L tracked',
                              AppColors.neonBlue),
                          const SizedBox(width: 12),
                          _metricTile('FATIGUE', 'LOW', 'Recovery Optimal',
                              AppColors.neonGreen),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─── Today's Schedule ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Schedule",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'VIEW ALL',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Match card
                    _scheduleCard(
                      context: context,
                      time: '18:00',
                      period: 'PM',
                      title: 'Pro-Open Badminton Match',
                      location: 'CyberArena, Sector 7',
                      intensity: 'HIGH',
                      energyColor: AppColors.neonPink,
                      energyLevel: 0.85,
                      hasMenu: true,
                    ),
                    const SizedBox(height: 12),

                    _scheduleCard(
                      context: context,
                      time: '20:30',
                      period: 'PM',
                      title: 'Post-Match Recovery',
                      location: 'Cryo-Lab A1',
                      intensity: 'LOW',
                      energyColor: AppColors.neonGreen,
                      energyLevel: 0.25,
                      hasMenu: false,
                    ),

                    const SizedBox(height: 28),

                    // ─── AI Coach Banner ──────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AiCoachPage()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppColors.aiGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.neonPurple
                                      .withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8)),
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
                                child: const Icon(Icons.smart_toy_rounded,
                                    color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('AI Coaching 24/7',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: 'SpaceGrotesk')),
                                    SizedBox(height: 4),
                                    Text(
                                        'Analyze performance & prevent injury',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Colors.white70),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─── Find Open Match CTA ──────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OpenMatchPage()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.bgSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.search_rounded,
                                    color: AppColors.primary, size: 24),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Find Your Next Challenge',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    SizedBox(height: 4),
                                    Text('Open matches near you',
                                        style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('JOIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(
            child: Text('Gagal memuat data',
                style: TextStyle(color: AppColors.error))),
      ),
    );
  }

  Widget _statCard(
      String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontFamily: 'SpaceGrotesk'),
                ),
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricTile(
      String label, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: AppColors.textTertiary),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontFamily: 'SpaceGrotesk'),
            ),
            const SizedBox(height: 4),
            Text(sub,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _scheduleCard({
    required BuildContext context,
    required String time,
    required String period,
    required String title,
    required String location,
    required String intensity,
    required Color energyColor,
    required double energyLevel,
    required bool hasMenu,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            // Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'SpaceGrotesk'),
                ),
                Text(period,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                        letterSpacing: 1)),
              ],
            ),
            const SizedBox(width: 16),
            // Divider line
            Container(width: 1, height: 48, color: AppColors.bgTertiary),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('CROWD ENERGY',
                          style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              color: AppColors.textTertiary)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: energyLevel,
                            backgroundColor:
                                AppColors.bgTertiary,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(energyColor),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        intensity,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: energyColor,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (hasMenu)
              const Icon(Icons.more_vert_rounded,
                  color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
