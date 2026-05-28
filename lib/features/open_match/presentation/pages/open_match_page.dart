import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/match_provider.dart';
import '../../domain/entities/match_entity.dart';
import 'create_match_page.dart';
import 'match_detail_page.dart';

class OpenMatchPage extends ConsumerStatefulWidget {
  const OpenMatchPage({super.key});

  @override
  ConsumerState<OpenMatchPage> createState() => _OpenMatchPageState();
}

class _OpenMatchPageState extends ConsumerState<OpenMatchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Badminton', 'Running', 'Near Me'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(openMatchesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Open Match Explorer',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: _filters.length,
                      itemBuilder: (_, i) {
                        final f = _filters[i];
                        final active = f == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.bgSecondary,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: active
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Live count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Live matches in your area',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
        body: matchesAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, _) => Center(
              child: Text('Error: $err',
                  style: const TextStyle(color: AppColors.error))),
          data: (matches) {
            if (matches.isEmpty) {
              return _buildEmptyState(context);
            }
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.bgSecondary,
              onRefresh: () async =>
                  Future.delayed(const Duration(seconds: 1)),
              child: ListView.separated(
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 100),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: matches.length,
                itemBuilder: (_, i) => _MatchCard(match: matches[i]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateMatchPage())),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('Buat Match',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Icon(Icons.sports_rounded,
                size: 56, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          const Text('No matches found',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Be the first to create an open match!',
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateMatchPage())),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Match'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends ConsumerWidget {
  final MatchEntity match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFull = match.currentPlayers >= match.maxPlayers;
    final bool isBadminton = match.sportType.name == 'badminton';
    final Color sportColor = isBadminton ? AppColors.neonBlue : AppColors.sportRunning;
    final IconData sportIcon = isBadminton
        ? Icons.sports_tennis_rounded
        : Icons.directions_run_rounded;
    final int slotsLeft = match.maxPlayers - match.currentPlayers;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MatchDetailPage(match: match)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top banner with sport image area ────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.bgTertiary,
                      sportColor.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Sport icon watermark
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(sportIcon,
                          size: 100,
                          color: sportColor.withValues(alpha: 0.08)),
                    ),
                    // Slot count badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.bgPrimary.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(sportIcon, size: 14, color: sportColor),
                            const SizedBox(width: 6),
                            Text(
                              match.sportType.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: sportColor,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Status badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isFull
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.neonGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isFull
                                  ? AppColors.error.withValues(alpha: 0.4)
                                  : AppColors.neonGreen
                                      .withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isFull
                                    ? AppColors.error
                                    : AppColors.neonGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isFull ? 'FULL' : '$slotsLeft SLOTS LEFT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isFull
                                    ? AppColors.error
                                    : AppColors.neonGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Player slots row (bottom)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Row(
                        children: [
                          ...List.generate(
                            match.maxPlayers > 6 ? 6 : match.maxPlayers,
                            (i) => Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < match.currentPlayers
                                    ? sportColor.withValues(alpha: 0.8)
                                    : AppColors.bgPrimary.withValues(alpha: 0.6),
                                border: Border.all(
                                    color: i < match.currentPlayers
                                        ? sportColor
                                        : Colors.white
                                            .withValues(alpha: 0.15),
                                    width: 1.5),
                              ),
                              child: i < match.currentPlayers
                                  ? Center(
                                      child: Text(
                                        (i + 1).toString(),
                                        style: const TextStyle(
                                            fontSize: 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          if (match.maxPlayers > 6)
                            Text(
                              '+${match.maxPlayers - 6}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textTertiary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Match body ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location + skill level
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          match.location,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              AppColors.bgTertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          match.skillLevel.name.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date + Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 5),
                      Text(
                        match.matchDate.toString().split(' ')[0],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 5),
                      Text(
                        match.timeSlot,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Host + Join button
                  Row(
                    children: [
                      // Host avatar
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            sportColor.withValues(alpha: 0.2),
                        child: Text(
                          match.hostName.isNotEmpty
                              ? match.hostName[0]
                              : '?',
                          style: TextStyle(
                              color: sportColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.hostName,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 11,
                                    color: AppColors.neonGold),
                                const SizedBox(width: 3),
                                Text(
                                  '${match.hostReliabilityScore.toInt()}% reliability',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // JOIN / Spectate button
                      if (!isFull)
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MatchDetailPage(match: match)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'JOIN MATCH',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5),
                          ),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MatchDetailPage(match: match)),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: BorderSide(
                                color:
                                    Colors.white.withValues(alpha: 0.12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'SPECTATE ONLY',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
