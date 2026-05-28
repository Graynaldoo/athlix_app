import 'package:flutter/material.dart';

/// Athlix Dark Futuristic Sports Design System
/// Primary palette: Deep Navy + Teal Neon + Glassmorphism
class AppColors {
  AppColors._();

  // ─── Background Surfaces ──────────────────────────────
  static const Color bgPrimary    = Color(0xFF0F172A); // Main scaffold bg
  static const Color bgSecondary  = Color(0xFF1E293B); // Card bg
  static const Color bgTertiary   = Color(0xFF263045); // Input, elevated card
  static const Color bgElevated   = Color(0xFF1A2540); // Modal, bottom sheet
  static const Color bgOverlay    = Color(0x99000000); // Scrim (60% black)

  // ─── Primary Accent — Teal/Neon ───────────────────────
  static const Color primary      = Color(0xFF0D9488); // Teal primary
  static const Color primaryLight = Color(0xFF14B8A6); // Lighter teal
  static const Color primaryDark  = Color(0xFF0A7066); // Darker teal
  static const Color primaryGlow  = Color(0x330D9488); // Glow (20% opacity)

  // ─── Neon Accents ─────────────────────────────────────
  static const Color neonBlue     = Color(0xFF00D4FF); // Highlights, links
  static const Color neonBlueGlow = Color(0x4D00D4FF); // Neon glow (30%)
  static const Color neonGreen    = Color(0xFF00FF88); // Success, score high
  static const Color neonPurple   = Color(0xFF8B5CF6); // AI, skill tree
  static const Color neonOrange   = Color(0xFFFF6B35); // Warnings, hot
  static const Color neonGold     = Color(0xFFFFD700); // Achievements, top rank
  static const Color neonPink     = Color(0xFFFF2D78); // Errors, destructive

  // ─── Text ─────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF8FAFC); // White primary text
  static const Color textSecondary = Color(0xFF94A3B8); // Muted subtext
  static const Color textTertiary  = Color(0xFF64748B); // Hints, placeholders
  static const Color textAccent    = Color(0xFF0D9488); // Accent text / links

  // ─── Status ───────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF97316);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ─── Sport Category Colors ────────────────────────────
  static const Color sportFootball   = Color(0xFF22C55E);
  static const Color sportBasketball = Color(0xFFEF4444);
  static const Color sportBadminton  = Color(0xFF3B82F6);
  static const Color sportTennis     = Color(0xFFF59E0B);
  static const Color sportSwimming   = Color(0xFF06B6D4);
  static const Color sportRunning    = Color(0xFF8B5CF6);
  static const Color sportVolleyball = Color(0xFFEC4899);
  static const Color sportCycling    = Color(0xFF14B8A6);

  // ─── Gradients ────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF0EA5E9)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF0099CC), Color(0xFF006699)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1A2540)],
  );

  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFF59E0B)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFEF4444)],
  );

  // ─── Glass Effect ─────────────────────────────────────
  /// Glass card background — use with BackdropFilter blur
  static Color get glassBg => bgSecondary.withValues(alpha: 0.5);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.08);
  static Color get glassBorderActive => Colors.white.withValues(alpha: 0.15);

  // ─── Reliability Score Colors ─────────────────────────
  static Color reliabilityColor(double score) {
    if (score >= 90) return neonGreen;
    if (score >= 70) return primary;
    if (score >= 50) return warning;
    return error;
  }

  // ─── Skill Level Colors ───────────────────────────────
  static const Map<String, Color> skillLevelColors = {
    'pemula':   Color(0xFF22C55E),
    'menengah': Color(0xFFF59E0B),
    'mahir':    Color(0xFFEF4444),
  };
}
