import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// A form label stacked above an outlined field, as in the design.
class LabelledField extends StatelessWidget {
  const LabelledField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: AppText.fieldLabel),
        const SizedBox(height: AppSpacing.fieldLabelGap),
        child,
      ],
    );
  }
}
