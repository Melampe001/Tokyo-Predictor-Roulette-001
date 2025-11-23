# Reglas de ProGuard para Tokyo Roulette Predicciones
# Este archivo define reglas de ofuscación y optimización para el build release

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Stripe
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

# Gson (usado por Firebase y otras librerías)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

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

# OkHttp (usado por Firebase y otras librerías de red)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Mantener clases de datos (si usas data classes)
-keepclassmembers class * {
    public <init>(...);
}

# Mantener información de línea para stack traces útiles
-keepattributes SourceFile,LineNumberTable

# Si usas serialización
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

# Mantener nombres de clases para reflection
-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
