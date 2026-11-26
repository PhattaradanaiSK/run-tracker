import 'package:flutter/material.dart';

import '../../models/run_entry.dart';
import '../../theme/tokens.dart';
import 'run_thumb.dart';

/// Thai card copy, exactly the pattern from the design spec.
String runCardWhereLine(String runWhere) => 'วิ่งที่ไหน: $runWhere';
String runCardDistanceLine(int runDistance) => 'วิ่งไปเท่าไหร่: $runDistance กม.';

/// One run row: alternating fill, leading photo (logo fallback),
/// two Thai lines, and the red "i" that opens Edit/Delete.
class RunCard extends StatelessWidget {
  const RunCard({
    super.key,
    required this.run,
    required this.index,
    required this.onTapInfo,
    this.photoResolver,
  });

  final RunEntry run;
  final int index;
  final VoidCallback onTapInfo;

  /// Null for offline demo data (local paths need no translation).
  final PhotoUrlResolver? photoResolver;

  @override
  Widget build(BuildContext context) {
    final fill =
        index.isEven ? AppColors.cardGreen : AppColors.cardGray;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RunPhoto(
                path: run.runImageUrl,
                size: AppSpacing.cardThumb,
                resolver: photoResolver,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      runCardWhereLine(run.runWhere),
                      style: AppText.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      runCardDistanceLine(run.runDistance),
                      style: AppText.cardSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: 'แก้ไขหรือลบ ${run.runWhere}',
                child: InkResponse(
                  onTap: onTapInfo,
                  radius: AppSpacing.cardBadge,
                  child: Container(
                    width: AppSpacing.cardBadge,
                    height: AppSpacing.cardBadge,
                    decoration: const BoxDecoration(
                      color: AppColors.buttonDanger,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'i',
                        style: TextStyle(
                          fontFamily: AppText.fontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          color: AppColors.textOnNavy,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
