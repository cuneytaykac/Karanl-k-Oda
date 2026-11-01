import 'package:flutter/painting.dart';

/// Karanlık Oda renk paleti.
/// Kanvastaki bütün ekranlar bu değerlerle çizildi; yeni renk eklemeden önce buraya bak.
abstract final class KoColor {
  // Zeminler
  static const background = Color(0xFF100E0D); // ekran arka planı
  static const backgroundDark = Color(0xFF0A0807); // banyo, kapanış sahnesi
  static const bottomNav = Color(0xFF0C0B0A);
  static const surface = Color(0xFF1B1816); // kart, sheet
  static const surface2 = Color(0xFF241F1C); // seçili satır, ikon zemini
  static const line = Color(0xFF2C2623); // ince ayraç, kart kenarı
  static const lineStrong = Color(0xFF3A322D); // pasif çip kenarı, boş ilerleme
  static const ghostBorder = Color(0xFF4A3B2E); // ikincil düğme kenarı

  // Metin
  static const text = Color(0xFFF0E7D8);
  static const textCream = Color(0xFFD9C9B2); // uzun paragraf
  static const textMuted = Color(0xFFB3A897);
  static const textDim = Color(0xFF958A7D);
  static const textDisabled = Color(0xFF6E655B); // kilitli, tamamlanmış ipucu

  // Kırmızı ışık (markanın ana vurgusu)
  static const redButton = Color(0xFFC23B2E);
  static const redButtonText = Color(0xFFF7EFE2);
  static const redText = Color(0xFFE5675A);
  static const safelight = Color(0xFFE0503F); // aktif kare, seçili kenar, ışık

  // Kâğıt (defter, fotoğraf kartları)
  static const paper = Color(0xFFEFE5D2);
  static const paperLine = Color(0xFFD2C4AC);
  static const paperLineThick = Color(0xFF8E7E6A); // 5'lik blok ayraçları
  static const ink = Color(0xFF1C1714);
  static const inkMuted = Color(0xFF5A4E44);
  static const paperLabel = Color(0xFFA8362A); // kâğıt üstü kırmızı etiket
  static const photoFrame = Color(0xFFEADFCB);

  // Kehribar (ipucu, ödül, bilgi)
  static const amber = Color(0xFFE8B27A);
  static const amberBorder = Color(0xFF5A4634);
  static const completed = Color(0xFFC9A27A); // banyo edilmiş kare çubuğu

  // Reklam alanları
  static const adBackground = Color(0xFF1E2328);
  static const adAccent = Color(0xFFC9A34E);

  // Durum
  static const correct = Color(0xFF4F6B3A);
}
