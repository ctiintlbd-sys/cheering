import 'package:flutter/material.dart';
import '../utils/assets/fonts.gen.dart';
import 'app_theme_colors.dart';

/// Minimalist, high-performance AppTheme.
/// All text and input styling is encapsulated within Custom widgets.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colors = AppThemeColors.lightTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: FontFamily.sFPro,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        surface: colors.background,
        onSurface: colors.textPrimary,
        error: colors.error,
        outline: colors.outline,
      ),
      extensions: [colors],
    );
  }

  static ThemeData dark() {
    final colors = AppThemeColors.darkTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: FontFamily.sFPro,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        surface: colors.background,
        onSurface: colors.textPrimary,
        error: colors.error,
        outline: colors.outline,
      ),
      extensions: [colors],
    );
  }
}
