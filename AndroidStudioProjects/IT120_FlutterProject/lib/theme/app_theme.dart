import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF87CEEB); // Baby blue
  static const Color secondaryColor = Color(0xFFB0E0E6); // Powder blue
  static const Color accentColor = Color(0xFF4682B4); // Steel blue
  static const Color backgroundColor = Color(0xFFF0F8FF); // Alice blue
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF0F8FF);
  static const Color primaryBlue = Color(0xFF87CEEB); // Baby blue
  static const Color primaryIndigo = Color(0xFF4682B4); // Steel blue
  static const Color accentTeal = Color(0xFF48D1CC); // Medium turquoise

  static const List<Color> classColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF96CEB4),
    Color(0xFFFECA57),
    Color(0xFF48C9B0),
    Color(0xFF9B59B6),
    Color(0xFFE74C3C),
    Color(0xFF3498DB),
    Color(0xFF2ECC71),
  ];

  static const List<String> classNames = [
    'Strawberry',
    'Blueberry',
    'Raspberry',
    'Blackberry',
    'Cranberry',
    'Gooseberry',
    'Elderberry',
    'Mulberry',
    'Boysenberry',
    'Loganberry',
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1565C0), // Darker blue for better contrast
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1976D2), // Medium blue for better readability
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF212121), // Dark text for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF424242), // Medium dark text
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: secondaryColor,
        secondary: accentColor,
        surface: const Color(0xFF1E1E1E),
        error: errorColor,
      ),
    );
  }
}
