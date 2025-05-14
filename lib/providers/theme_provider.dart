import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  Future<void> _loadThemeFromStorage() async {
    try {
      String? themeString = await _storage.read(key: 'theme_mode');
      if (themeString != null) {
        if (themeString == 'dark') {
          _themeMode = ThemeMode.dark;
        } else if (themeString == 'light') {
          _themeMode = ThemeMode.light;
        } else {
          _themeMode = ThemeMode.system;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme from storage: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      String themeString;
      switch (mode) {
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.light:
          themeString = 'light';
          break;
        default:
          themeString = 'system';
      }

      await _storage.write(key: 'theme_mode', value: themeString);
    } catch (e) {
      debugPrint('Error saving theme to storage: $e');
    }
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
