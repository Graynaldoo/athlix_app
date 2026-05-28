import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutQuart));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.neonPink,
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background glow
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 48),

                        // Header
                        const Text(
                          'ACCESS\nPROTOCOL.',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The Future of Athletics',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Email field
                        const Text(
                          'ATHLETE ID (EMAIL)',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textTertiary,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle:
                                TextStyle(color: AppColors.textTertiary),
                            prefixIcon: Icon(Icons.email_outlined,
                                color: AppColors.textTertiary, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Email wajib diisi';
                            }
                            if (!v.contains('@')) return 'Email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Security Key field
                        const Text(
                          'SECURITY KEY',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textTertiary,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle:
                                const TextStyle(color: AppColors.textTertiary),
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppColors.textTertiary, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textTertiary,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password wajib diisi';
                            }
                            if (v.length < 6) return 'Minimal 6 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Forgot password
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'RECOVER ACCESS',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // AUTHENTICATE button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : const Text(
                                    'AUTHENTICATE',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withValues(alpha: 0.08))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR ACCESS VIA',
                                  style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      color: AppColors.textTertiary)),
                            ),
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withValues(alpha: 0.08))),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Social buttons
                        Row(
                          children: [
                            Expanded(
                              child: _socialButton(
                                icon: Icons.g_mobiledata_rounded,
                                label: 'Google',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _socialButton(
                                icon: Icons.apple_rounded,
                                label: 'Apple ID',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'NO ATHLETE PROFILE YET? ',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1,
                                color: AppColors.textSecondary,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, anim, __) =>
                                      const RegisterPage(),
                                  transitionsBuilder: (_, anim, __, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                ),
                              ),
                              child: const Text(
                                'INITIALIZE NOW',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SpaceGrotesk',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}