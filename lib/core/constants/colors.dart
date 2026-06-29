import 'package:flutter/material.dart';

/// Samaj App — Premium Color Palette
/// Theme: Warm Gujarati Saffron + Gold + Maroon
class AppColors {

  // ── Primary — Deep Saffron ─────────────────────────────────────────────────
  static const Color primary        = Color(0xFFE8621A); // Main saffron
  static const Color primaryDark    = Color(0xFFC0501A); // Darker saffron
  static const Color primaryLight   = Color(0xFFFF8A50); // Lighter saffron
  static const Color primarySurface = Color(0xFFFFF0E8); // Very light saffron bg

  // ── Secondary — Deep Maroon ────────────────────────────────────────────────
  static const Color secondary      = Color(0xFF7B1F3A); // Rich maroon
  static const Color secondaryDark  = Color(0xFF5A1429); // Deeper maroon
  static const Color secondaryLight = Color(0xFFA52B50); // Lighter maroon

  // ── Accent — Gold ─────────────────────────────────────────────────────────
  static const Color accent         = Color(0xFFD4A017); // Warm gold
  static const Color accentLight    = Color(0xFFFFD166); // Light gold
  static const Color accentSurface  = Color(0xFFFFF8E1); // Gold surface tint

  // ── Dark Ink ──────────────────────────────────────────────────────────────
  static const Color darkInk        = Color(0xFF1A0E06); // Very dark warm brown
  static const Color darkSurface    = Color(0xFF2D1A10); // Dark card surface

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color backgroundCream = Color(0xFFFFF8F2); // Warm cream
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white
  static const Color backgroundLight = Color(0xFFF9F2EC); // Light warm grey
  static const Color surfaceCard     = Color(0xFFFFFFFF); // Card surface

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A0E06); // Dark ink
  static const Color textSecondary = Color(0xFF7A5A48); // Warm grey-brown
  static const Color textMuted     = Color(0xFFB09080); // Muted warm
  static const Color textWhite     = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Border ────────────────────────────────────────────────────────────────
  static const Color borderLight   = Color(0xFFEDE0D4); // Warm light border
  static const Color borderMedium  = Color(0xFFD4B8A8); // Medium border
  static const Color borderPrimary = Color(0xFFE8621A); // Saffron border

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color error   = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color info    = Color(0xFF1565C0);

  // ── Navigation ────────────────────────────────────────────────────────────
  static const Color navActive   = Color(0xFFE8621A); // Saffron active
  static const Color navInactive = Color(0xFFB09080); // Muted inactive

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE8621A), Color(0xFFD4A017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientV = LinearGradient(
    colors: [Color(0xFFE8621A), Color(0xFFD4A017)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A0E06), Color(0xFF2D1A10)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFFE8621A), Color(0xFFD4A017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7B1F3A), Color(0xFFE8621A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Card Gradients for Home Grid ──────────────────────────────────────────
  static const LinearGradient gridCard1 = LinearGradient(colors: [Color(0xFFE8621A), Color(0xFFFF8A50)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gridCard2 = LinearGradient(colors: [Color(0xFF7B1F3A), Color(0xFFA52B50)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gridCard3 = LinearGradient(colors: [Color(0xFFD4A017), Color(0xFFFFD166)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gridCard4 = LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gridCard5 = LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gridCard6 = LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)], begin: Alignment.topLeft, end: Alignment.bottomRight);
}
