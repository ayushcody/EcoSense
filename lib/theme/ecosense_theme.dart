import 'package:flutter/material.dart';

final ColorScheme ecosenseColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFA98467), // Warm tan
  onPrimary: Colors.white,
  secondary: Color(0xFFDFC7C1), // Soft pink
  onSecondary: Color(0xFF4A403A), // Dark brown
  error: Color(0xFFB00020),
  onError: Colors.white,
  surface: Color(0xFFF7F3E9), // Antique white
  onSurface: Color(0xFF4A403A), // Dark brown
  background: Color(0xFFF7F3E9), // Matching surface for backward compatibility
  surfaceTint: Color(0xFFF7F3E9),
);

final ColorScheme ecosenseDarkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFB5A38D), // Lighter tan
  onPrimary: Color(0xFF1C1C1C),
  secondary: Color(0xFFDFC7C1), // Soft pink
  onSecondary: Color(0xFF1C1C1C),
  error: Color(0xFFCF6679),
  onError: Colors.black,
  surface: Color(0xFF2D2A25), // Dark beige
  onSurface: Color(0xFFE8E6E1), // Light beige
  background: Color(0xFF2D2A25), // Matching surface for backward compatibility
  surfaceTint: Color(0xFF2D2A25),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ecosenseColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: ecosenseColorScheme.primary,
    foregroundColor: ecosenseColorScheme.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ecosenseColorScheme.primary,
      foregroundColor: ecosenseColorScheme.onPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ecosenseColorScheme.onBackground,
    ),
    bodyLarge: TextStyle(
      color: ecosenseColorScheme.onBackground,
    ),
    bodyMedium: TextStyle(
      color: ecosenseColorScheme.onBackground.withAlpha(178),
    ),
  ),
  scaffoldBackgroundColor: ecosenseColorScheme.surface,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ecosenseDarkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: ecosenseDarkColorScheme.surface,
    foregroundColor: ecosenseDarkColorScheme.onSurface,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: ecosenseDarkColorScheme.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ecosenseDarkColorScheme.primary,
      foregroundColor: ecosenseDarkColorScheme.onPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ecosenseDarkColorScheme.onBackground,
    ),
    bodyLarge: TextStyle(
      color: ecosenseDarkColorScheme.onBackground,
    ),
    bodyMedium: TextStyle(
      color: ecosenseDarkColorScheme.onBackground.withAlpha(178),
    ),
  ),
  scaffoldBackgroundColor: ecosenseDarkColorScheme.surface,
);
