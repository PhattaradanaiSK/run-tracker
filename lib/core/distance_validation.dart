/// Result of validating the three required form fields.
class DistanceValidation {
  const DistanceValidation._(this.error);

  /// Null when the input is valid.
  final String? error;

  bool get isValid => error == null;
}

/// Thai message shown when ระยะทาง is not a whole number.
const String kDistanceError = 'กรุณากรอกระยะทางเป็นจำนวนเต็ม';

/// Thai message shown when a required field is blank.
const String kRequiredError = 'กรุณากรอกข้อมูลให้ครบ';

/// Validates ระยะทาง: must parse as a whole integer and be >= 0.
///
/// Rejects empty input, whitespace, decimals, letters, signs and
/// thousands separators.
DistanceValidation validateDistance(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const DistanceValidation._(kRequiredError);
  if (!RegExp(r'^\d+$').hasMatch(text)) {
    return const DistanceValidation._(kDistanceError);
  }
  final value = int.tryParse(text);
  if (value == null) return const DistanceValidation._(kDistanceError);
  if (value < 0) return const DistanceValidation._(kDistanceError);
  return const DistanceValidation._(null);
}

/// Validates the whole Add / Edit form.
///
/// Returns the first Thai error message, or null when the form may be saved.
/// Photo is optional and never blocks saving.
String? validateRunForm({
  required String runWhere,
  required String runPerson,
  required String runDistance,
}) {
  if (runWhere.trim().isEmpty) return kRequiredError;
  if (runPerson.trim().isEmpty) return kRequiredError;
  return validateDistance(runDistance).error;
}
