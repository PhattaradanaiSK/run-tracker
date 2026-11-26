import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/tokens.dart';
import 'brand_logo.dart';
import 'labelled_field.dart';
import 'primary_button.dart';
import 'run_thumb.dart';

/// Thai copy for the Add / Edit form, exactly as in the design.
abstract final class RunFormCopy {
  const RunFormCopy._();

  static const String whereLabel = 'วิ่งที่ไหน';
  static const String whereHint = 'เช่น สวนสาธารณะ, สนามกีฬา หรือ อื่นๆ';
  static const String personLabel = 'วิ่งกับใคร';
  static const String personHint = 'เช่น เพื่อน 3 คน, แฟน หรือ อื่นๆ';
  static const String distanceLabel = 'ระยะทาง';
  static const String distanceHint = 'เช่น 1, 5, 11 หรือ อื่นๆ';

  static const String addTitle = 'Run Tracker (เพิ่ม)';
  static const String editTitle = 'Run Tracker (แก้ไข/ลบ)';

  static const String saveLabel = 'บันทึกข้อมูล';
  static const String cancelLabel = 'ยกเลิก';
  static const String updateLabel = 'บันทึกแก้ไขข้อมูล';
  static const String deleteLabel = 'ลบข้อมูล';
}

/// The camera slot at the top of Add and Edit.
///
/// Empty state shows the grey camera-plus placeholder; once a photo exists the
/// picture replaces it, and the slot stays tappable to retake.
class PhotoSlot extends StatelessWidget {
  const PhotoSlot({
    super.key,
    required this.onTap,
    this.photoPath,
    this.showLogoFallback = false,
    this.photoResolver,
  });

  final VoidCallback onTap;
  final String? photoPath;

  /// Null for offline demo data; set when photos live in the `run_bk` bucket.
  final PhotoUrlResolver? photoResolver;

  /// Edit shows the brand logo when the row has no photo.
  final bool showLogoFallback;

  static const double _height = 130;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final hasPhoto = path != null && path.isNotEmpty;

    return Semantics(
      button: true,
      label: 'ถ่ายภาพ',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: _height,
          width: double.infinity,
          child: Center(
            child: hasPhoto
                ? RunPhoto(
                    path: path,
                    size: _height,
                    resolver: photoResolver,
                    borderRadius: 14,
                  )
                : showLogoFallback
                    ? const BrandLogo(width: 118)
                    : const Icon(
                        Icons.add_a_photo_outlined,
                        size: AppSpacing.cameraPlaceholderSize,
                        color: AppColors.cameraIcon,
                      ),
          ),
        ),
      ),
    );
  }
}

/// The three Thai fields plus the green/red buttons, shared by Add and Edit.
class RunForm extends StatelessWidget {
  const RunForm({
    super.key,
    required this.whereController,
    required this.personController,
    required this.distanceController,
    required this.primaryLabel,
    required this.onPrimary,
    required this.dangerLabel,
    required this.onDanger,
    this.busy = false,
  });

  final TextEditingController whereController;
  final TextEditingController personController;
  final TextEditingController distanceController;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String dangerLabel;
  final VoidCallback? onDanger;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LabelledField(
          label: RunFormCopy.whereLabel,
          child: TextField(
            controller: whereController,
            style: AppText.fieldText,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: RunFormCopy.whereHint),
          ),
        ),
        const SizedBox(height: 22),
        LabelledField(
          label: RunFormCopy.personLabel,
          child: TextField(
            controller: personController,
            style: AppText.fieldText,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: RunFormCopy.personHint),
          ),
        ),
        const SizedBox(height: 22),
        LabelledField(
          label: RunFormCopy.distanceLabel,
          child: TextField(
            controller: distanceController,
            style: AppText.fieldText,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: RunFormCopy.distanceHint,
            ),
            onSubmitted: (_) => onPrimary?.call(),
          ),
        ),
        const SizedBox(height: 41),
        PrimaryButton(
          label: primaryLabel,
          color: AppColors.buttonSave,
          onPressed: onPrimary,
          busy: busy,
        ),
        const SizedBox(height: AppSpacing.primaryButtonGap),
        PrimaryButton(
          label: dangerLabel,
          color: AppColors.buttonDanger,
          onPressed: busy ? null : onDanger,
        ),
      ],
    );
  }
}
