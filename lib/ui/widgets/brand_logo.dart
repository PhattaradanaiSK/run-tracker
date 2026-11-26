import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// The running-figure brand mark, rebuilt as a PNG asset from the design.
///
/// Used on Splash, Show all (empty and filled), the Edit photo slot fallback,
/// and as the list thumbnail fallback.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.width = AppSpacing.brandLogoWidth});

  final double width;

  static const String assetPath = 'assets/images/logo_mark.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      // The mark sits directly on both navy and light surfaces.
      excludeFromSemantics: true,
      semanticLabel: 'Run Tracker',
    );
  }
}
