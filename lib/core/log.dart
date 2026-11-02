import 'package:flutter/foundation.dart';

/// Geliştirme kaydı: yalnızca debug derlemede konsola yazar. Release'te
/// (mağaza sürümü) hiçbir şey yazılmaz.
void devLog(String message) {
  if (kDebugMode) debugPrint(message);
}
