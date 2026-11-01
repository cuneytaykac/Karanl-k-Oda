import 'dart:ui';

import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../../domain/entities/photo_spec.dart';

/// DATA · Örnek içerik: içerikte bulunmayan kareler (ve testler) için yedek bulmaca ve fotoğraf.
abstract final class SamplePuzzles {
  /// Rulo 2 · Kare 4 · balık (10×10). Tahminsiz çözülebildiği testle doğrulandı.
  static final fish = Puzzle.fromRows(const [
    '..........',
    '..####...#',
    '.######.##',
    '##.#######',
    '##########',
    '##########',
    '.######.##',
    '..####...#',
    '...##.....',
    '..........',
  ]);

  /// Bu karenin çözülünce ortaya çıkan fotoğrafı.
  static const fishPhoto = 'assets/case_files/wrong_man/photos/r2_k3_lake.svg';

  /// Göl fotoğrafı ve içindeki ayrıntı: kol saati 12:30.
  /// Saatin SVG'deki merkezi (205, 262); yarıçap biraz geniş tutuldu ki parmakla bulunabilsin.
  static const lakePhoto = PhotoSpec(
    asset: fishPhoto,
    title: 'Göl kıyısı',
    date: '3 Mart 1989',
    hotspots: [
      Hotspot(
        id: 'wrong_man.r2.watch',
        center: Offset(205, 262),
        radius: 22,
        tag: '12:30',
        title: 'Necati göldeydi',
        body: 'Soygun saatinde kolundaki saat 12:30\'u gösteriyor.',
      ),
    ],
  );

  static Puzzle puzzleFor(String caseId, int reel, int frame) => fish;

  static String photoFor(String caseId, int reel, int frame) => fishPhoto;

  static PhotoSpec photoSpecFor(String caseId, int reel, int frame) =>
      lakePhoto;
}
