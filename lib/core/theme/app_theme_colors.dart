import 'package:flutter/material.dart';

import 'palette/dark_color_palette.dart';
import 'palette/light_color_palette.dart';


/// Complete Figma-synchronized Theme Color Extension.
/// All variable names match Figma design tokens (camelCase format).
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // ── Brand Colors ───────────────────────────────────────────
  final Color primary;
  final Color primaryLight;
  final Color secondary;

  // ── Background Colors ──────────────────────────────────────
  final Color background;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color bgErrorPrimary;
  final Color bgErrorSecondary;
  final Color bgErrorSecondaryHover;
  final Color bgSuccessPrimary;
  final Color bgSuccessSecondary;
  final Color bgWarningSecondary;
  final Color bgInfoPrimary;

  // ── Standard Pure Colors ──────────────────────────────────
  final Color white;
  final Color black;

  // ── Border & Outline (Figma: border/primary, border/secondary, border/outline)
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;
  final Color outline;

  // ── Text Colors ───────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textPlaceholder;
  final Color textAccentSolid;


  // ── Semantic Status Colors ─────────────────────────────────
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  final Color blue500;
  final Color ratingColor;

  // ── Icon Colors ────────────────────────────────────
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;

  // ── Shimmer Colors ─────────────────────────────────────────
  final Color shimmerBase;
  final Color shimmerHighlight;

  @protected
  const AppThemeColors.internal({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.background,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.bgErrorPrimary,
    required this.bgErrorSecondary,
    required this.bgErrorSecondaryHover,
    required this.bgSuccessPrimary,
    required this.bgSuccessSecondary,
    required this.bgWarningSecondary,
    required this.bgInfoPrimary,
    required this.white,
    required this.black,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderTertiary,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textPlaceholder,
    required this.textAccentSolid,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.blue500,
    required this.ratingColor,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  static AppThemeColors get lightTheme => lightColorPalette;

  static AppThemeColors get darkTheme => darkColorPalette;

  @override
  AppThemeColors copyWith() => this;

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) => other ?? this;
}

extension AppThemeContext on BuildContext {
  AppThemeColors get colors {
    final ext = Theme.of(this).extension<AppThemeColors>();
    if (ext != null) return ext;
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? AppThemeColors.darkTheme : AppThemeColors.lightTheme;
  }

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
