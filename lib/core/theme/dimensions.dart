/// Boşluk, köşe yarıçapı ve boyut ölçüleri (mantıksal piksel).
/// Tasarım 390×844 telefon ekranına göre yapıldı.
abstract final class KoSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16; // ekran kenar boşluğu
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

abstract final class KoRadius {
  static const double small = 8; // küçük foto, etiket
  static const double medium = 12; // çip içi, mini düğme
  static const double icon = 14; // 44×44 ikon düğmesi
  static const double button = 16; // ana düğme
  static const double card = 20;
  static const double cardLarge = 22;
  static const double sheet = 26; // alttan açılan pencere
  static const double pill = 999; // çip, rozet
}

abstract final class KoSize {
  static const double buttonTall = 56;
  static const double buttonMedium = 50;
  static const double iconButton = 44; // en küçük dokunma alanı
  static const double bottomNavHeight = 80;
}
