import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../router/app_router.dart';
import '../widgets/brand_logo.dart';

/// Splash: navy, logo, italic RUN TRACKER, a short progress arc, footer.
class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key, this.delay = const Duration(milliseconds: 1600)});

  /// Auto-advance delay before moving to the run list.
  final Duration delay;

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (!mounted) return;
      // Replace so the back button never returns to the splash.
      context.go(AppRoutes.showAll);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const BrandLogo(width: 170),
                  const SizedBox(height: 40),
                  const Text('RUN TRACKER', style: AppText.wordmark),
                  const SizedBox(height: 38),
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.logoBody.withValues(alpha: 0.9),
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('© 2026 RUN TRACKER', style: AppText.footer),
                    Text('Created by NinniN SAU TEAM', style: AppText.footer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
