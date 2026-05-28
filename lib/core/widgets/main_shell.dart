import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/open_match/presentation/pages/open_match_page.dart';
import '../../features/training_log/presentation/pages/training_log_page.dart';
import '../../features/venue/presentation/pages/venue_finder_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../constants/app_colors.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TrainingLogPage(),
    OpenMatchPage(),
    VenueFinderPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glassmorphism nav bar
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.bgSecondary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Beranda',
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _NavItem(
                    icon: Icons.fitness_center_rounded,
                    label: 'Latihan',
                    isSelected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _NavItem(
                    icon: Icons.sports_soccer_rounded,
                    label: 'Match',
                    isSelected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                    isCenter: true,
                  ),
                  _NavItem(
                    icon: Icons.location_on_rounded,
                    label: 'Venue',
                    isSelected: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profil',
                    isSelected: _currentIndex == 4,
                    onTap: () => setState(() => _currentIndex = 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCenter;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.neonBlue.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.neonBlue.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: const Icon(
            Icons.sports_soccer_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected ? AppColors.neonBlue : AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 4 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neonBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.neonBlue.withValues(alpha: 0.5),
                      blurRadius: 6,
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

