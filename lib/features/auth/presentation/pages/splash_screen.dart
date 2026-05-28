import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background radial glow
          Positioned(
            top: -100,
            left: -100,
            right: -100,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),

          // Athlete silhouette background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.bgPrimary,
                    AppColors.bgPrimary.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Column(
                      children: [
                        // Logo mark
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: AppColors.heroGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.bolt_rounded,
                              size: 48, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        // ATHLIX wordmark
                        const Text(
                          'ATHLIX',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Tagline
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            'The Future of Athletics',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Unlock your peak performance with\nprecision data and cinematic training insights.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Progress bar
                FadeTransition(
                  opacity: _textFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'INITIALIZING CORE',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: AppColors.textTertiary,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _progress,
                              builder: (_, __) => Text(
                                '${(_progress.value * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  color: AppColors.primary,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedBuilder(
                          animation: _progress,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _progress.value,
                              backgroundColor:
                                  AppColors.bgTertiary,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                              minHeight: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
