import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// One ThemeData for the whole app, built from the design tokens.
ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.light,
      surface: AppColors.surface,
      primary: AppColors.navy,
      onPrimary: AppColors.textOnNavy,
    ).copyWith(
      surface: AppColors.surface,
      primary: AppColors.navy,
      onPrimary: AppColors.textOnNavy,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    fontFamily: AppText.fontFamily,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: AppText.fontFamily,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.navy,
      foregroundColor: AppColors.textOnNavy,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: AppSpacing.appBarHeight,
      titleTextStyle: AppText.appBarTitle,
      iconTheme: IconThemeData(color: AppColors.textOnNavy, size: 30),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.navy,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: AppText.fieldText.copyWith(color: AppColors.textHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        borderSide: const BorderSide(color: AppColors.fieldOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        borderSide: const BorderSide(color: AppColors.fieldOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        borderSide: const BorderSide(color: AppColors.buttonDanger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        borderSide: const BorderSide(color: AppColors.buttonDanger, width: 1.4),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.navy,
      contentTextStyle: TextStyle(
        fontFamily: AppText.fontFamily,
        color: AppColors.textOnNavy,
        fontSize: 15,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      titleTextStyle: AppText.fieldLabel.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: AppText.fieldText.copyWith(color: AppColors.textSecondary),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.logoBody,
    ),
  );
}
