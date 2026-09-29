import 'package:flutter/material.dart';

import '../app_theme_colors.dart';

/// Figma Light Mode Palette (Exact Figma tokens)
final lightColorPalette = AppThemeColors.internal(
  // Brand
  primary: const Color(0xFFE2146E),
  primaryLight: const Color(0xFFFDF2F8),
  secondary: const Color(0xFFEC4899),

  // Background
  background: const Color(0xFFFFFFFF),
  bgSecondary: const Color(0xFFF8FAFC),
  bgTertiary: const Color(0xFFF1F5F9),
  bgErrorPrimary: const Color(0x1ADC2626),
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
  borderPrimary: const Color(0xFFCBD5E1),
  borderSecondary: const Color(0xFFCBD5E1),
  borderTertiary: const Color(0xFFF1F5F9),
  outline: const Color(0xFFE2E8F0),

  // Text
  textPrimary: const Color(0xFF0F172A),
  textSecondary: const Color(0xFF475569),
  textTertiary: const Color(0xFF64748B),
  textPlaceholder: const Color(0xFF94A3B8),
  textAccentSolid: const Color(0xFFE2146E),

  // Status
  error: const Color(0xFFDC2626),
  success: const Color(0xFF16A34A),
  warning: const Color(0xFFF59E0B),
  info: const Color(0xFF2563EB),
  blue500: const Color(0xFF3B82F6),
  ratingColor: const Color(0xFFFACC15),

  // Icons
  iconPrimary: const Color(0xFF0F172A),
  iconSecondary: const Color(0xFF475569),
  iconTertiary: const Color(0xFF94A3B8),

  // Shimmer
  shimmerBase: const Color(0xFFE2E8F0),
  shimmerHighlight: const Color(0xFFF1F5F9),
);
