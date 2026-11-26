import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Navy rounded-square FAB with a heavy white plus.
///
/// The design uses a squircle, not the default circular FAB.
class NavyFab extends StatelessWidget {
  const NavyFab({super.key, required this.onPressed, this.label = 'เพิ่มข้อมูล'});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppSpacing.fabRadius),
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const SizedBox(
            width: AppSpacing.fabSize,
            height: AppSpacing.fabSize,
            child: Icon(Icons.add, color: AppColors.textOnNavy, size: 32),
          ),
        ),
      ),
    );
  }
}
