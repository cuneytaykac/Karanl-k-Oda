import 'dart:ui';

/// DOMAIN · Bir fotoğrafın içerik tanımı: dosya yolu ve büyüteçle bulunacak ayrıntılar.
/// Koordinatlar SVG'nin kendi ölçeğindedir (viewBox 300×400), ekran boyutundan bağımsız.
class PhotoSpec {
  const PhotoSpec({
    required this.asset,
    required this.title,
    required this.date,
    this.hotspots = const [],
  });

  final String asset;
  final String title; // "Göl kıyısı"
  final String date; // "3 Mart 1989"
  final List<Hotspot> hotspots;

  static const Size canvas = Size(300, 400);
}

/// Bulunan ayrıntı deftere hangi sekmeye düşer.
enum HotspotKind {
  /// İpuçları sekmesi.
  clue,

  /// Zaman çizelgesi (tag alanında saat: "10:40").
  time,

  /// Kişiler sekmesi: [Hotspot.personId] o kişiyi tanıtır.
  person,
}

/// Fotoğraftaki bulunabilir ayrıntı. Bulununca deftere düşer.
class Hotspot {
  const Hotspot({
    required this.id,
    required this.center,
    required this.radius,
    required this.title,
    required this.body,
    this.tag,
    this.kind = HotspotKind.clue,
    this.personId,
  });

  /// Defterde tekil kimlik, örn. "wm.r1.t1040".
  final String id;

  /// SVG koordinatında merkez ve yakalama yarıçapı.
  final Offset center;
  final double radius;

  final String title; // "Necati göldeydi"
  final String body; // açıklama
  final String? tag; // kart üstündeki kısa etiket: "12:30"
  final HotspotKind kind;
  final String? personId;

  /// [point] (SVG koordinatı) bu ayrıntının üstünde mi?
  bool contains(Offset point) => (point - center).distance <= radius;
}
