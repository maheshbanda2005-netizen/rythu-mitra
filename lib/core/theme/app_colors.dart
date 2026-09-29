import 'package:flutter/material.dart';

/// Professional agriculture-fintech color palette tailored for Rythu Mitra
class AppColors {
  AppColors._();

  // Primary Greens
  static const Color primary = Color(0xFF1B5E20); // Deep Forest Green
  static const Color primaryMedium = Color(0xFF2E7D32); // Vibrant Agricultural Green
  static const Color primaryLight = Color(0xFF4CAF50); // Leaf Green
  static const Color primaryContainer = Color(0xFFE8F5E9); // Ultra-light green tint
  static const Color primaryContainerDark = Color(0xFF1E382B);

  // Secondary & Accents
  static const Color secondary = Color(0xFF00796B); // Deep Teal Green
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color accentAmber = Color(0xFFF59E0B); // Golden Grain / Market Rate
  static const Color accentOrange = Color(0xFFEA580C); // Harvest Orange
  static const Color accentBlue = Color(0xFF0284C7); // Water / Irrigation
  static const Color accentPurple = Color(0xFF7C3AED); // Soil & Chemicals

  // Status & Warnings
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626); // Critical disease alert
  static const Color info = Color(0xFF2563EB);

  // Light Mode Neutrals
  static const Color backgroundLight = Color(0xFFF6F8F5); // Clean subtle sage-white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFEDF2EC);
  static const Color borderLight = Color(0xFFE0E7DE);
  static const Color textPrimaryLight = Color(0xFF111D13);
  static const Color textSecondaryLight = Color(0xFF526053);
  static const Color textTertiaryLight = Color(0xFF889689);

  // Dark Mode Neutrals
  static const Color backgroundDark = Color(0xFF0D1610);
  static const Color surfaceDark = Color(0xFF15221A);
  static const Color surfaceVariantDark = Color(0xFF1E3025);
  static const Color borderDark = Color(0xFF263D30);
  static const Color textPrimaryDark = Color(0xFFF0FDF4);
  static const Color textSecondaryDark = Color(0xFFA7BAAC);
  static const Color textTertiaryDark = Color(0xFF718274);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D3E14), Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient marketGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient weatherGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlassGradient = LinearGradient(
    colors: [Color(0xEEFFFFFF), Color(0xDDF4FAF4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Jade Sky Gradient (matching the new GradientBackground component)
  static const LinearGradient jadeSkyGradient = LinearGradient(
    colors: [Color(0xFFCFE9F0), Color(0xFFEEF6E3), Color(0xFFB7D98E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Modern accent gradients
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
