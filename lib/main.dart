import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'core/constants/app_theme.dart';
import 'core/widgets/main_shell.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id', null);
  runApp(const ProviderScope(child: AthlixApp()));
}

class AthlixApp extends ConsumerWidget {
  const AthlixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Athlix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: authState.when(
        data: (user) => user != null
            ? const MainShell()
            : const SplashScreen(),
        loading: () => const Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SplashScreen(),
      ),
    );
  }
}