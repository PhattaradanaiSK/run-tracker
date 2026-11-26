import 'package:flutter/material.dart';

/// Design tokens from the Figma reference screens.
/// Prefer these values over hardcoding a hex in a widget.
abstract final class AppColors {
  const AppColors._();

  /// Brand navy: splash bg, app bars, FAB.
  static const Color navy = Color(0xFF001551);

  /// Material 3 purple-tinted page background.
  static const Color surface = Color(0xFFFEF7FF);

  static const Color textPrimary = Color(0xFF000000);
  static const Color textHint = Color(0xFF6B6B6B);

  /// Subtitles on cards (slightly muted, still readable).
  static const Color textSecondary = Color(0xFF3D3D3D);
  static const Color textOnNavy = Color(0xFFFFFFFF);

  /// Splash copyright lines: low contrast on navy, measured ~#5A5C60.
  static const Color textFooter = Color(0xFF6E7286);

  /// Material Green 500 — save / update buttons.
  static const Color buttonSave = Color(0xFF4CAF50);

  /// Material Red 500 — cancel / delete buttons, red "i" badge.
  static const Color buttonDanger = Color(0xFFF44336);

  /// Material 3 outline (slightly purple gray).
  static const Color fieldOutline = Color(0xFF9A949F);

  /// Material Grey 300 — camera placeholder.
  static const Color cameraIcon = Color(0xFFE0E0E0);

  /// Material Green 50 — even-index cards.
  static const Color cardGreen = Color(0xFFE8F5E9);

  /// Material Grey 100 — odd-index cards.
  static const Color cardGray = Color(0xFFF5F5F5);

  // Logo palette (rebuilt into assets/images/logo_mark.png).
  static const Color logoBody = Color(0xFF60B0F8);
  static const Color logoLeg = Color(0xFF4080B0);
  static const Color logoHead = Color(0xFFF0B068);
  static const Color logoChevronPink = Color(0xFFF86880);
  static const Color logoChevronYellow = Color(0xFFF8B830);
}

/// Spacing and sizing, in logical dp, scaled from a ~430 dp wide frame.
abstract final class AppSpacing {
  const AppSpacing._();

  /// App bar height.
  static const double appBarHeight = 56;

  /// Horizontal inset for fields and primary buttons (~350 dp wide on 430).
  static const double pageInset = 40;

  static const double buttonHeight = 49;

  /// Gap between the green and red primary buttons.
  static const double primaryButtonGap = 30;

  static const double fieldHeight = 47;
  static const double fieldRadius = 8;

  /// Label-to-outline gap.
  static const double fieldLabelGap = 6;

  static const double buttonRadius = 10;

  /// Navy squircle FAB.
  static const double fabSize = 66;
  static const double fabRadius = 20;
  static const double fabBottomPadding = 14;

  /// Brand logo width on splash / show all.
  static const double brandLogoWidth = 170;

  /// Logo width on the edit screen slot.
  static const double editLogoWidth = 128;

  static const double cardRadius = 18;
  static const double cardGap = 10;

  /// Card leading thumbnail.
  static const double cardThumb = 52;

  /// Card trailing red "i" badge.
  static const double cardBadge = 30;

  /// Camera placeholder icon.
  static const double cameraPlaceholderSize = 130;
}

/// Text styles. Prompt is bundled (assets/fonts) so Thai renders offline.
abstract final class AppText {
  const AppText._();

  static const String fontFamily = 'Prompt';

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textOnNavy,
  );

  /// Italic uppercase splash wordmark, generous letter spacing.
  static const TextStyle wordmark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    letterSpacing: 3.2,
    color: AppColors.textOnNavy,
  );

  /// "วิ่งกันเถอะ"
  static const TextStyle slogan = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle footer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textFooter,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle fieldText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnNavy,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.textSecondary,
  );
}
