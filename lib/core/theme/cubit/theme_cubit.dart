import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themePreferenceKey);

    if (themeModeIndex != null) {
      final themeMode = ThemeMode.values[themeModeIndex];
      emit(ThemeState(themeMode: themeMode));
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _themePreferenceKey, ThemeMode.values.indexOf(themeMode));
    emit(state.copyWith(themeMode: themeMode));
  }

  bool get isDarkMode => state.themeMode == ThemeMode.dark;
  bool get isLightMode => state.themeMode == ThemeMode.light;
  bool get isSystemMode => state.themeMode == ThemeMode.system;
}
