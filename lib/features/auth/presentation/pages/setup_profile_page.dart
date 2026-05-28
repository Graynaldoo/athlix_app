import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/main_shell.dart';

class SetupProfilePage extends ConsumerStatefulWidget {
  const SetupProfilePage({super.key});

  @override
  ConsumerState<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends ConsumerState<SetupProfilePage>
    with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  int _currentStep = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Weight (kg)',
      'subtitle': 'Your body weight in kilograms',
      'unit': 'KG',
      'icon': Icons.monitor_weight_outlined,
      'keyboard': TextInputType.number,
    },
    {
      'title': 'Height (cm)',
      'subtitle': 'Your height in centimeters',
      'unit': 'CM',
      'icon': Icons.height_rounded,
      'keyboard': TextInputType.number,
    },
    {
      'title': 'Age',
      'subtitle': 'How old are you?',
      'unit': 'YRS',
      'icon': Icons.cake_outlined,
      'keyboard': TextInputType.number,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  TextEditingController get _currentController {
    switch (_currentStep) {
      case 0: return _weightController;
      case 1: return _heightController;
      default: return _ageController;
    }
  }

  void _next() {
    if (_currentController.text.isEmpty) return;
    if (_currentStep < 2) {
      _animController.reset();
      setState(() => _currentStep++);
      _animController.forward();
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  radius: 0.9,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Step indicator
                  Row(
                    children: List.generate(3, (i) {
                      final active = i == _currentStep;
                      final done = i < _currentStep;
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: done || active
                                ? AppColors.primary
                                : AppColors.bgTertiary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Step ${_currentStep + 1} of 3',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Step header animation
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(step['icon'] as IconData,
                              color: AppColors.primary, size: 32),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Large number input
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _currentController,
                            keyboardType: step['keyboard'] as TextInputType,
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                            decoration: const InputDecoration(
                              hintText: '000',
                              hintStyle: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 56,
                                fontWeight: FontWeight.w800,
                                color: AppColors.bgTertiary,
                                letterSpacing: 4,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            step['unit'] as String,
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: AppColors.bgTertiary, height: 1),

                  const Spacer(),

                  // CONTINUE button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentStep == 2 ? 'VIEW WORKOUT PLAN' : 'CONTINUE',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
