import 'package:flutter/material.dart';

class AppColors {
  // ============ LIGHT THEME ============
  // Background Colors
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color premiumScaffoldBackground = Color(0xFFFFFFFF); // Unified
  
  // Primary Colors - Green
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryDark = Color(0xFF46A302);
  
  // Premium Primary Colors (Lighter Green)
  static const Color premiumPrimary = Color(0xFF7BDE12);
  static const Color premiumPrimaryDark = Color(0xFF5EB00E);
  
  // Secondary Blue
  static const Color secondaryBlue = Color(0xFF1CB0F6);
  static const Color secondaryBlueDark = Color(0xFF1899D6);
  
  // Secondary Yellow
  static const Color secondaryYellow = Color(0xFFFFC800);
  static const Color secondaryYellowDark = Color(0xFFE5A400);
  
  // Premium Gold Colors
  static const Color premiumGold = Color(0xFFFFC107);
  static const Color premiumGoldDark = Color(0xFFE6AD00);
  
  // Danger Colors
  static const Color danger = Color(0xFFFF4B4B);
  static const Color dangerDark = Color(0xFFD33131);
  
  // Neon Pink (for expenses)
  static const Color neonPink = Color(0xFFFF4B91);
  
  // Gray Colors (Light)
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF151B0D);
  
  // Card Colors (Light)
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE5E7EB);
  static const Color cardShadowLight = Color(0xFFE5E7EB);
  
  // ============ DARK THEME ============
  // Background Colors (Dark)
  static const Color scaffoldBackgroundDark = Color(0xFF131F24);
  static const Color premiumScaffoldBackgroundDark = Color(0xFF131F24); // Unified
  
  // Card Colors (Dark)
  static const Color cardDark = Color(0xFF1F2D33);
  static const Color premiumCardDark = Color(0xFF1F2D33); // Unified
  static const Color premiumCardDark2 = Color(0xFF1F2D33); // Unified
  static const Color cardBorderDark = Color(0xFF37464F);
  static const Color premiumCardBorderDark = Color(0xFF37464F); // Unified
  static const Color cardShadowDark = Color(0xFF151B1F);
  static const Color premiumCardShadowDark = Color(0xFF151B1F); // Unified
  
  // Gray Colors (Dark)
  static const Color grayDark100 = Color(0xFF37464F);
  static const Color grayDark400 = Color(0xFF9CA3AF);
  static const Color grayDark500 = Color(0xFF6B7280);
  
  // Text Colors (Dark)
  static const Color textLight = Color(0xFFFFFFFF);
  
  // ============ THEME-AWARE HELPERS ============
  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardDark : cardLight;
  
  static Color cardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardBorderDark : cardBorderLight;
  
  static Color cardShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardShadowDark : cardShadowLight;
  
  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textLight : textDark;
  
  static Color progressBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? grayDark100 : gray100;
  
  static Color subtitleText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? grayDark400 : gray400;
  
  static Color expenseColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? neonPink : Colors.red.shade500;
  
  // Premium Helpers
  static Color premiumBackground(bool isDark) =>
      isDark ? premiumScaffoldBackgroundDark : premiumScaffoldBackground;
      
  static Color premiumSurface(bool isDark) =>
      isDark ? premiumCardDark : cardLight;
      
  static Color premiumBorder(bool isDark) =>
      isDark ? premiumCardBorderDark : cardBorderLight;
      
  static Color premiumText(bool isDark) =>
      isDark ? textLight : textDark;
      
  static Color premiumSubText(bool isDark) =>
      isDark ? gray400 : gray500;
  
  // ============ LEGACY (keeping for compatibility) ============
  static const Color primaryCardColor = Color(0xFF58CC02);
  static const Color primaryCardShadow = Color(0xFF46A302);
  static const Color statBoxColor = Color(0xFF58CC02);
  static const Color statBoxShadow = Color(0xFF46A302);
  static const Color primaryTextOnCard = Color(0xFF131F24);
  static const Color backgroundDark = Color(0xFF131F24);
  
  // ============ CONSTANTS ============
  // Border Radius
  static const double cardBorderRadius = 24.0;
  static const double statBoxBorderRadius = 24.0;
  
  // Spacing
  static const double cardPadding = 24.0;
  static const double statBoxPadding = 16.0;
  
  // Shadow
  static const Offset cardShadowOffset = Offset(0, 4);
  static const Offset statBoxShadowOffset = Offset(0, 4);
}
