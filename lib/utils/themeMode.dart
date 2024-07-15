import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String prefsKey = "theme_mode";
  ThemeCubit() : super(ThemeMode.light) {
    getTheme();
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      saveTheme(ThemeMode.dark);
    } else {
      saveTheme(ThemeMode.light);
    }
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsKey, themeMode == ThemeMode.dark ? "dark" : "light");
    emit(themeMode);
  }

  Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(prefsKey);
    if (themeString != null) {
      emit(themeString == "dark" ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
