# Flutter ProGuard rules
# These rules ensure Flutter and its plugins work correctly when minified

# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Firebase classes (if using Firebase)
-keep class com.google.firebase.** { *; }

# Keep Stripe classes (if using Stripe)
-keep class com.stripe.** { *; }

# Preserve line number information for debugging
-keepattributes SourceFile,LineNumberTable
