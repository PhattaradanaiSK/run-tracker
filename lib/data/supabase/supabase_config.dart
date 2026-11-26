import '../../core/app_config.dart';

/// Where the Supabase values come from, and why nothing is hardcoded.
///
/// Values are read only from `--dart-define` (`SUPABASE_URL`,
/// `SUPABASE_ANON_KEY`) or `--dart-define-from-file=.env`. There is deliberately
/// no default and no fallback literal: a missing value leaves the option off.
class SupabaseConfig {
  const SupabaseConfig({required this.url, required this.anonKey});

  final String url;
  final String anonKey;

  /// Table and bucket names from the design. They are not configurable.
  static const String tableName = 'run_tb';
  static const String bucketName = 'run_bk';

  bool get isComplete => url.isNotEmpty && anonKey.isNotEmpty;

  /// Reads the compile-time environment. Never logs the key.
  factory SupabaseConfig.fromEnvironment() {
    final app = AppConfig.fromEnvironment();
    return SupabaseConfig(
      url: app.supabaseUrl,
      anonKey: app.supabaseAnonKey,
    );
  }

  @override
  String toString() =>
      'SupabaseConfig(urlConfigured: ${url.isNotEmpty}, '
      'anonKeyConfigured: ${anonKey.isNotEmpty})';
}
