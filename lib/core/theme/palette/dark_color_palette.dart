import 'package:flutter/material.dart';

import '../app_theme_colors.dart';

/// Dark Mode Palette (Synchronized with Figma tokens)
final darkColorPalette = AppThemeColors.internal(
  // Brand
  primary: const Color(0xFFE2146E),
  primaryLight: const Color(0xFF831843),
  secondary: const Color(0xFFEC4899),

  // Background
  background: const Color(0xFF0F172A),
  bgSecondary: const Color(0xFF1E293B),
  bgTertiary: const Color(0xFF334155),
  bgErrorPrimary: const Color(0x1AEF4444),
  bgErrorSecondary: const Color(0xFFDC2626),
  bgErrorSecondaryHover: const Color(0xFFB91C1C),
  bgSuccessPrimary: const Color(0x1A16A34A),
  bgSuccessSecondary: const Color(0xFF16A34A),
  bgWarningSecondary: const Color(0xFFEA580C),
  bgInfoPrimary: const Color(0xFF2563EB),

  // Pure
  white: const Color(0xFFFFFFFF),
  black: const Color(0xFF000000),

  // Borders
  borderPrimary: const Color(0xFF475569),
  borderSecondary: const Color(0xFF475569),
  borderTertiary: const Color(0xFF334155),
  outline: const Color(0xFF334155),

  // Text
  textPrimary: const Color(0xFFF8FAFC),
  textSecondary: const Color(0xFF94A3B8),
  textTertiary: const Color(0xFFCBD5E1),
  textPlaceholder: const Color(0xFF64748B),
  textAccentSolid: const Color(0xFFF472B6),

  // Status
  error: const Color(0xFFEF4444),
  success: const Color(0xFF22C55E),
  warning: const Color(0xFFFBBF24),
  info: const Color(0xFF3B82F6),
  blue500: const Color(0xFF3B82F6),
  ratingColor: const Color(0xFFFACC15),

  // Icons
  iconPrimary: const Color(0xFFF8FAFC),
  iconSecondary: const Color(0xFF94A3B8),
  iconTertiary: const Color(0xFF64748B),

  // Shimmer
  shimmerBase: const Color(0xFF1E293B),
  shimmerHighlight: const Color(0xFF334155),
);
