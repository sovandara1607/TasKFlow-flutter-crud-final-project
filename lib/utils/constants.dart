import 'package:flutter/material.dart';

/// Tiimo‑inspired application‑wide constants.
class AppConstants {
  // ── Primary palette (soft lavender) ──
  static const Color primaryColor = Color(0xFF8B7EC8);
  static const Color primaryLight = Color(0xFFB8ACE6);
  static const Color primaryDark = Color(0xFF6B5CA5);

  // ── Backgrounds ──
  static const Color backgroundColor = Color(0xFFF8F6FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // ── Pastel accents ──
  static const Color accentPink = Color(0xFFF0C6DB);
  static const Color accentMint = Color(0xFFA8E6CF);
  static const Color accentPeach = Color(0xFFFFD3B6);
  static const Color accentLavender = Color(0xFFD4C5F9);
  static const Color accentSky = Color(0xFFB6D8F2);

  // ── Semantic colors ──
  static const Color successColor = Color(0xFF6BCB77);
  static const Color warningColor = Color(0xFFFFB347);
  static const Color errorColor = Color(0xFFFF6B6B);

  // ── Text colors ──
  static const Color textPrimary = Color(0xFF2D2B3D);
  static const Color textSecondary = Color(0xFF8E8CA3);
  static const Color textLight = Color(0xFFB8B5C8);

  // ── Strings ──
  static const String appName = 'TaskFlow';

  // ── Padding / Radius ──
  static const double defaultPadding = 20.0;
  static const double cardRadius = 20.0;
  static const double defaultRadius = 16.0;

  // ── Status emoji ──
  static String statusEmoji(String status) {
    switch (status) {
      case 'in_progress':
        return '⏳';
      case 'completed':
        return '✅';
      default:
        return '📋';
    }
  }

  // ── Status colours ──
  static Color statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return warningColor;
      case 'completed':
        return successColor;
      default:
        return primaryColor;
    }
  }

  // ── Status card background (pastel) ──
  static Color statusBgColor(String status) {
    switch (status) {
      case 'in_progress':
        return accentPeach;
      case 'completed':
        return accentMint;
      default:
        return accentLavender;
    }
  }

  // ── Status icons ──
  static IconData statusIcon(String status) {
    switch (status) {
      case 'in_progress':
        return Icons.timelapse_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.radio_button_unchecked;
    }
  }
}
