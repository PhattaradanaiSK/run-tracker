/// One run log row.
///
/// Field names mirror the Supabase `public.run_tb` columns exactly
/// (`id`, `created_at`, `runWhere`, `runPerson`, `runDistance`, `runImageUrl`)
/// so the offline and remote repositories can share one model.
class RunEntry {
  const RunEntry({
    required this.id,
    required this.createdAt,
    required this.runWhere,
    required this.runPerson,
    required this.runDistance,
    this.runImageUrl,
  });

  final String id;
  final DateTime createdAt;
  final String runWhere;
  final String runPerson;

  /// Whole kilometers (`int4` in the table).
  final int runDistance;

  /// Local file path (offline demo) or Storage path / public URL (Supabase).
  final String? runImageUrl;

  RunEntry copyWith({
    String? id,
    DateTime? createdAt,
    String? runWhere,
    String? runPerson,
    int? runDistance,
    String? runImageUrl,
    bool clearImage = false,
  }) {
    return RunEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      runWhere: runWhere ?? this.runWhere,
      runPerson: runPerson ?? this.runPerson,
      runDistance: runDistance ?? this.runDistance,
      runImageUrl: clearImage ? null : (runImageUrl ?? this.runImageUrl),
    );
  }

  /// Maps to the `run_tb` row shape (camelCase quoted identifiers kept as-is).
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt.toUtc().toIso8601String(),
        'runWhere': runWhere,
        'runPerson': runPerson,
        'runDistance': runDistance,
        'runImageUrl': runImageUrl,
      };

  factory RunEntry.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'];
    final rawDistance = json['runDistance'];
    return RunEntry(
      id: json['id'] as String? ?? '',
      createdAt: rawDate is String
          ? (DateTime.tryParse(rawDate) ?? DateTime.now())
          : (rawDate is DateTime ? rawDate : DateTime.now()),
      runWhere: (json['runWhere'] as String?) ?? '',
      runPerson: (json['runPerson'] as String?) ?? '',
      runDistance: rawDistance is int
          ? rawDistance
          : int.tryParse('${rawDistance ?? ''}') ?? 0,
      runImageUrl: json['runImageUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunEntry &&
          other.id == id &&
          other.createdAt == createdAt &&
          other.runWhere == runWhere &&
          other.runPerson == runPerson &&
          other.runDistance == runDistance &&
          other.runImageUrl == runImageUrl;

  @override
  int get hashCode =>
      Object.hash(id, createdAt, runWhere, runPerson, runDistance, runImageUrl);

  @override
  String toString() =>
      'RunEntry(id: $id, runWhere: $runWhere, runDistance: $runDistance)';
}

/// Values collected by the Add / Edit form before it touches a repository.
class RunDraft {
  const RunDraft({
    required this.runWhere,
    required this.runPerson,
    required this.runDistance,
    this.photoPath,
  });

  final String runWhere;
  final String runPerson;
  final int runDistance;

  /// A newly captured local file; null means "keep whatever is stored".
  final String? photoPath;
}
