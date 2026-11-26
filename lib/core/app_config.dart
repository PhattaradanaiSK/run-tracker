/// Compile-time configuration.
///
/// Secrets are never committed. Supabase values are read only from
/// `--dart-define` (or `--dart-define-from-file=.env`). When they are absent,
/// the app uses offline demo data so it can still start.
class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;
  final String supabaseAnonKey;

  /// True only when both values were supplied at build time.
  bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Reads the dart-define values. Never falls back to a hardcoded key.
  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }

  /// Redacted one-liner, safe to log or show in the UI.
  String describe() => hasSupabaseConfig
      ? 'Supabase config: present (url host configured)'
      : 'Supabase config: absent (offline demo data in use)';
}
