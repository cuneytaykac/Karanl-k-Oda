# Release derlemesinde kod küçültücü (R8), yalnızca Dart'tan JNI ile çağrılan
# Java sınıflarını "kullanılmıyor" sanıp silebiliyor. path_provider_android 2.3+
# JNI'ye geçti (jni / jni_flutter); bu sınıflar korunmazsa uygulama açılışta çöker.
-keep class com.github.dart_lang.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keepclassmembers class * { native <methods>; }
