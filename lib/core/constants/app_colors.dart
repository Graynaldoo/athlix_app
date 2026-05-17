import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF1D9E75);
  static const Color primaryLight = Color(0xFF4ECBA0);
  static const Color primaryDark = Color(0xFF0D7A57);
  static const Color primaryContainer = Color(0xFFE0F5ED);

  // Secondary palette
  static const Color secondary = Color(0xFF2D6CDF);
  static const Color secondaryLight = Color(0xFF6B9BF0);
  static const Color secondaryContainer = Color(0xFFDDE8FC);

  // Accent
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFCD34D);
  static const Color accentContainer = Color(0xFFFEF3C7);

  // Sport category colors
  static const Color sportFootball = Color(0xFF22C55E);
  static const Color sportBasketball = Color(0xFFEF4444);
  static const Color sportBadminton = Color(0xFF3B82F6);
  static const Color sportTennis = Color(0xFFF59E0B);
  static const Color sportSwimming = Color(0xFF06B6D4);
  static const Color sportRunning = Color(0xFF8B5CF6);
  static const Color sportVolleyball = Color(0xFFEC4899);
  static const Color sportCycling = Color(0xFF14B8A6);

  // Surfaces
  static const Color surface = Color(0xFFF8FAFB);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D9E75), Color(0xFF0EA5E9)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );
}
