# Flutter's own consumer rules cover the engine. Keep the plugin entry points
# that the release shrinker could otherwise strip.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# image_picker uses AndroidX activity results.
-keep class androidx.lifecycle.** { *; }
-dontwarn io.flutter.embedding.**

# supabase_flutter / http / crypto stack reflectively touch some members.
-keep class org.jetbrains.kotlin.** { *; }
-dontwarn org.jetbrains.kotlin.**
