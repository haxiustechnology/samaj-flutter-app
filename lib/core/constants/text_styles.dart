import 'package:flutter/material.dart';
import 'colors.dart';

/// Samaj App — Typography System
/// Headings: Poppins | Body: Nunito
class AppTextStyles {

  // ── Font Family Constants ──────────────────────────────────────────────────
  static const String _headingFont = 'Poppins';
  static const String _bodyFont    = 'Nunito';

  // ── Display / Hero ────────────────────────────────────────────────────────
  static const TextStyle display = TextStyle(
    fontFamily: _headingFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayWhite = TextStyle(
    fontFamily: _headingFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  static const TextStyle heading1 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle heading1White = TextStyle(
    fontFamily: _headingFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle heading2White = TextStyle(
    fontFamily: _headingFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Subtitle ──────────────────────────────────────────────────────────────
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontFamily: _headingFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMediumSecondary = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Labels ────────────────────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontFamily: _headingFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _headingFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ── Button ────────────────────────────────────────────────────────────────
  static const TextStyle buttonText = TextStyle(
    fontFamily: _headingFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _headingFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  // ── Caption / Helper ──────────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle helper = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // ── Navigation Labels ─────────────────────────────────────────────────────
  static const TextStyle navLabel = TextStyle(
    fontFamily: _headingFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // ── App Bar Title ─────────────────────────────────────────────────────────
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _headingFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  // ── Special OTP / Number display ─────────────────────────────────────────
  static const TextStyle otp = TextStyle(
    fontFamily: _headingFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 8,
  );
}
