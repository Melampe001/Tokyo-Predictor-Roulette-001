# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# Firebase (descomentar cuando se configure)
# -keepattributes Signature
# -keepattributes *Annotation*
# -keepattributes EnclosingMethod
# -keepattributes InnerClasses
# -keep class com.google.firebase.** { *; }
# -keep class com.google.android.gms.** { *; }

# Stripe (descomentar cuando se configure)
# -keep class com.stripe.** { *; }
# -keepclassmembers class * extends com.stripe.android.core.model.StripeModel {
#     <fields>;
# }
