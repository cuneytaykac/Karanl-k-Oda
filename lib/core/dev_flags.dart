import 'package:flutter/foundation.dart';

/// GELİŞTİRME AYARLARI. Yalnızca geliştirirken (debug) açıktır; mağaza sürümünde
/// kendiliğinden kapanır, elle kapatmaya gerek yok.

/// Bulmaca ekranının sağ üstünde "Atla" düğmesi: bulmacayı anında çözer.
/// Rulo geçişlerini ve reklamları hızlıca denemek için.
const bool kDevSkipButton = kDebugMode;

/// Geçiş reklamı her rulo arasında çıkar (10 dakika bekleme ve ipucu reklamından
/// sonraki ara yok sayılır). İlk rulo yine reklamsız.
const bool kDevFrequentAdBreaks = kDebugMode;
