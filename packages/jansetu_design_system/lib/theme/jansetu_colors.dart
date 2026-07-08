import 'package:flutter/material.dart';

/// Official JanSetu AI Color Palette & Design Tokens
/// Follows the "Calm, Minimal, AI-First" design philosophy.
class JanSetuColors {
  JanSetuColors._();

  // Core Brand Palette
  static const Color slateNavy = Color(0xFF0F172A); // Primary dark brand color / Executive Slate
  static const Color electricBlue = Color(0xFF2563EB); // AI Actions & Interactive accents
  static const Color emeraldGreen = Color(0xFF10B981); // Resolved / Active / Positive SLAs
  static const Color crimsonAlert = Color(0xFFEF4444); // Critical Deficits / Stalled Projects
  static const Color saffronGold = Color(0xFFF59E0B); // In Progress / Warnings / MPLADS allocations

  // Background & Surface Colors (Light Mode)
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Background & Surface Colors (Dark Mode / Command Center)
  static const Color darkBg = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Priority Score Colors
  static Color getPriorityColor(double score) {
    if (score >= 90.0) return crimsonAlert;
    if (score >= 75.0) return saffronGold;
    if (score >= 60.0) return electricBlue;
    return emeraldGreen;
  }
}
