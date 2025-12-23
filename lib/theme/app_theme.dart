import 'package:flutter/material.dart';

/// Material Design 3 Theme Configuration for Tokyo Roulette
/// 
/// Provides custom color schemes, typography, and component themes
/// for both light and dark modes with a casino-themed aesthetic.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Casino-themed color palette
  static const Color _primaryRed = Color(0xFFD32F2F);
  static const Color _primaryGold = Color(0xFFFFD700);
  static const Color _casinoGreen = Color(0xFF2E7D32);
  static const Color _casinoBlack = Color(0xFF1A1A1A);
  static const Color _casinoWhite = Color(0xFFFAFAFA);
  
  /// Light theme configuration
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryRed,
      brightness: Brightness.light,
      primary: _primaryRed,
      secondary: _primaryGold,
      tertiary: _casinoGreen,
      surface: _casinoWhite,
      background: const Color(0xFFF5F5F5),
      error: const Color(0xFFB00020),
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryRed,
      brightness: Brightness.dark,
      primary: _primaryRed,
      secondary: _primaryGold,
      tertiary: _casinoGreen,
      surface: const Color(0xFF1E1E1E),
      background: _casinoBlack,
      error: const Color(0xFFCF6679),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  /// Common theme builder for light and dark modes
  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      
      // Typography
      textTheme: _buildTextTheme(colorScheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: isDark ? 2 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark 
          ? colorScheme.surface.withOpacity(0.4)
          : colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        backgroundColor: colorScheme.surface,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withOpacity(0.6),
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary.withOpacity(0.2),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Typography system following Material Design 3
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles - largest text
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurface,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
    );
  }
}

/// Theme extensions for custom properties
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? rouletteRed;
  final Color? rouletteBlack;
  final Color? rouletteGreen;
  final Color? gold;
  final Color? silver;
  final Color? bronze;
  
  const CustomColors({
    this.rouletteRed,
    this.rouletteBlack,
    this.rouletteGreen,
    this.gold,
    this.silver,
    this.bronze,
  });

  @override
  CustomColors copyWith({
    Color? rouletteRed,
    Color? rouletteBlack,
    Color? rouletteGreen,
    Color? gold,
    Color? silver,
    Color? bronze,
  }) {
    return CustomColors(
      rouletteRed: rouletteRed ?? this.rouletteRed,
      rouletteBlack: rouletteBlack ?? this.rouletteBlack,
      rouletteGreen: rouletteGreen ?? this.rouletteGreen,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      bronze: bronze ?? this.bronze,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      rouletteRed: Color.lerp(rouletteRed, other.rouletteRed, t),
      rouletteBlack: Color.lerp(rouletteBlack, other.rouletteBlack, t),
      rouletteGreen: Color.lerp(rouletteGreen, other.rouletteGreen, t),
      gold: Color.lerp(gold, other.gold, t),
      silver: Color.lerp(silver, other.silver, t),
      bronze: Color.lerp(bronze, other.bronze, t),
    );
  }

  static const CustomColors light = CustomColors(
    rouletteRed: Color(0xFFD32F2F),
    rouletteBlack: Color(0xFF1A1A1A),
    rouletteGreen: Color(0xFF2E7D32),
    gold: Color(0xFFFFD700),
    silver: Color(0xFFC0C0C0),
    bronze: Color(0xFFCD7F32),
  );

  static const CustomColors dark = CustomColors(
    rouletteRed: Color(0xFFEF5350),
    rouletteBlack: Color(0xFF2A2A2A),
    rouletteGreen: Color(0xFF66BB6A),
    gold: Color(0xFFFFD700),
    silver: Color(0xFFC0C0C0),
    bronze: Color(0xFFCD7F32),
  );
}
