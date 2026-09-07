import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/theme_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeStorage.getThemeMode());

  void updateTheme(ThemeMode mode) {
    ThemeStorage.saveThemeMode(mode);
    emit(mode);
  }

  String get currentThemeName {
    if (state == ThemeMode.light) return 'Light';
    if (state == ThemeMode.dark) return 'Dark';
    return 'System';
  }

  void updateThemeFromName(String themeName) {
    ThemeMode newMode = ThemeMode.system;
    if (themeName == 'Light') newMode = ThemeMode.light;
    if (themeName == 'Dark') newMode = ThemeMode.dark;
    updateTheme(newMode);
  }
}
