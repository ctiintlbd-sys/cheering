import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/theme_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeStorage.getThemeMode());

  void updateTheme(ThemeMode mode) {
    ThemeStorage.saveThemeMode(mode);
    emit(mode);
  }
}
