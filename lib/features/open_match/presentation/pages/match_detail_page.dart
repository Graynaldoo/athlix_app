import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/match_entity.dart';
import '../providers/match_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class MatchDetailPage extends ConsumerWidget {
  final MatchEntity match;
  const MatchDetailPage({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    final matchState = ref.watch(matchNotifierProvider);
    
    final bool isHost = currentUser?.uid == match.hostId;
    final bool hasJoined = match.joinedPlayerIds.contains(currentUser?.uid);
    final bool isFull = match.currentPlayers >= match.maxPlayers;

    ref.listen(matchNotifierProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        ),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.neonBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.neonBlue.withValues(alpha: 0.3), blurRadius: 20),
                        ],
                      ),
                      child: Icon(
                        match.sportType.name == 'badminton' ? Icons.sports_tennis_rounded : Icons.directions_run_rounded,
                        size: 48,
                        color: AppColors.neonBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Open Match ${match.sportType.name.toUpperCase()}',
                      style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _infoRow(Icons.location_on_outlined, 'LOCATION', match.location),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                        _infoRow(Icons.calendar_today_outlined, 'DATE', DateFormat('EEEE, dd MMM yyyy', 'en_US').format(match.matchDate)),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                        _infoRow(Icons.access_time_rounded, 'TIME', match.timeSlot),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                        _infoRow(Icons.star_border_rounded, 'SKILL LEVEL', match.skillLevel.name.toUpperCase()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Host Info
                  const Text('MATCH HOST', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary,
                          child: Text(match.hostName[0], style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(match.hostName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: AppColors.neonGold, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Reliability: ${match.hostReliabilityScore.toInt()}%', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  if (match.notes != null && match.notes!.isNotEmpty) ...[
                    const Text('ADDITIONAL NOTES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgTertiary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(match.notes!, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ROSTER', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1)),
                      Text('${match.currentPlayers}/${match.maxPlayers} FILLED', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      match.maxPlayers,
                      (index) {
                        if (index < match.currentPlayers) {
                          // Avatar terisi
                          return const CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.bgTertiary,
                            child: Icon(Icons.person_rounded, color: AppColors.textSecondary),
                          );
                        } else {
                          // Slot kosong
                          return CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1), style: BorderStyle.solid),
                              ),
                              child: const Center(child: Icon(Icons.add_rounded, color: AppColors.textTertiary, size: 18)),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Padding untuk bottom CTA
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: _buildActionButtons(context, ref, isHost, hasJoined, isFull, matchState.isLoading),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isHost, bool hasJoined, bool isFull, bool isLoading) {
    if (isHost) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : () {}, // TBD Edit
              child: const Text('EDIT MATCH', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _confirmDelete(context, ref),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonPink),
              child: const Text('CANCEL MATCH', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      );
    }

    if (hasJoined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : () => ref.read(matchNotifierProvider.notifier).leaveMatch(match.id),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.warning, side: const BorderSide(color: AppColors.warning)),
          child: isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.warning, strokeWidth: 2))
            : const Text('LEAVE MATCH', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (isFull) {
      return const SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          child: Text('MATCH FULL', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => ref.read(matchNotifierProvider.notifier).joinMatch(match.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text('JOIN MATCH', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Match?', style: TextStyle(fontFamily: 'SpaceGrotesk')),
        content: const Text('Are you sure you want to cancel this match? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('BACK', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(matchNotifierProvider.notifier).deleteMatch(match.id);
              Navigator.pop(context); // Go back to list
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonPink),
            child: const Text('YES, CANCEL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
