import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// The wide green / red action button used on Add and Edit.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: double.infinity,
      child: Material(
        color: enabled ? color : color.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Center(
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.textOnNavy,
                    ),
                  )
                : Text(label, style: AppText.button),
          ),
        ),
      ),
    );
  }
}
