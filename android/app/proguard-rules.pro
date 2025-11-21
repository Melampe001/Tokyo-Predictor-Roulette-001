# Minimal ProGuard rules. Adjust per dependencies.
-keep class com.yourapp.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep class com.google.firebase.messaging.** { *; }
