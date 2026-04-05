import 'package:flutter/material.dart';

const String appName = 'FinanceFlow';
const String currencySymbol = '₹';
const String currencyCode = 'INR';

class AppColors {
  // India-inspired color scheme (Saffron, White, Green)
  static const Color primary = Color(0xFFF97316); // Saffron
  static const Color secondary = Color(0xFF059669); // India Green
  static const Color accent = Color(0xFF1E40AF); // Deep Blue
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Semantic colors
  static const Color incomeGreen = Color(0xFF059669);
  static const Color expenseRed = Color(0xFFDC2626);
  static const Color savingsBlue = Color(0xFF1E40AF);

  // Backgrounds
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1F000000);
  static const Color border = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
}

class AppShadow {
  static const shadow = BoxShadow(
    color: AppColors.shadowColor,
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const shadowLarge = BoxShadow(
    color: AppColors.shadowColor,
    blurRadius: 20,
    offset: Offset(0, 8),
  );
}
