import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.bgPrimary,

      colorScheme: const ColorScheme.dark(
        primary:          AppColors.primary,
        secondary:        AppColors.primaryLight,
        surface:          AppColors.bgSecondary,
        error:            AppColors.error,
        onPrimary:        AppColors.textPrimary,
        onSecondary:      AppColors.textPrimary,
        onSurface:        AppColors.textPrimary,
        onError:          AppColors.textPrimary,
        primaryContainer: AppColors.bgTertiary,
        surfaceContainerHighest: AppColors.bgElevated,
      ),

      // ─── AppBar ─────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.bgPrimary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),

      // ─── Cards ──────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // ─── Inputs ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgTertiary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        hintStyle: const TextStyle(color: AppColors.textTertiary),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),

      // ─── Elevated Buttons ────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ─── Outlined Buttons ────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Text Buttons ────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── FAB ─────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ─── Bottom Nav ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgSecondary,
        indicatorColor: AppColors.primaryGlow,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textTertiary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          );
        }),
      ),

      // ─── SnackBar ────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        elevation: 8,
      ),

      // ─── Bottom Sheet ────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.textTertiary,
      ),

      // ─── Dialog ──────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      // ─── Chips ───────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgTertiary,
        selectedColor: AppColors.primaryGlow,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ─── Divider ─────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.08),
        thickness: 1,
        space: 1,
      ),

      // ─── List Tile ───────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      ),

      // ─── Switch ──────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textTertiary),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primaryGlow
            : Colors.white.withValues(alpha: 0.1)),
      ),

      // ─── Text Theme ──────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'SpaceGrotesk', fontSize: 40, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -1.5, height: 1.1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'SpaceGrotesk', fontSize: 32, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -1.0, height: 1.2,
        ),
        displaySmall: TextStyle(
          fontFamily: 'SpaceGrotesk', fontSize: 28, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.25,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.3, height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: 0, height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: 0, height: 1.35,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: 0, height: 1.4,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: 0.1, height: 1.4,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: 0.3, height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400,
          color: AppColors.textPrimary, letterSpacing: 0, height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary, letterSpacing: 0, height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary, letterSpacing: 0.2, height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: 0.5, height: 1.2,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500,
          color: AppColors.textSecondary, letterSpacing: 0.5, height: 1.2,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w500,
          color: AppColors.textTertiary, letterSpacing: 0.8, height: 1.2,
        ),
      ),
    );
  }
}
