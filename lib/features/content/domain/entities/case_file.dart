import '../../../puzzle/domain/nonogram/puzzle.dart';
import 'photo_spec.dart';

/// DOMAIN · Bir Dosya'nın tüm içeriği. Saf veri: JSON'u ya da Flutter'ı bilmez.
/// JSON'dan okuma `data/models/case_file_mapper.dart` içinde.
class CaseFile {
  const CaseFile({
    required this.id,
    required this.number,
    required this.title,
    required this.summary,
    required this.tags,
    required this.intro,
    required this.people,
    required this.reels,
    this.reelCount = 0,
    this.timelineTitle = '',
    this.timelineDate = '',
    this.timeline = const [],
    this.finale,
  });

  final String id;
  final int number;
  final String title;
  final String summary;
  final List<String> tags;
  final List<IntroLine> intro;
  final List<Person> people;
  final List<Reel> reels;

  /// Dosyadaki toplam rulo sayısı (içeriği henüz yazılmamış rulolar dahil).
  final int reelCount;

  /// Defterdeki zaman çizelgesinin başlığı, örn. "3 Mart 1989 · Cumartesi".
  final String timelineTitle;

  /// Baştan bilinen olayların günü ("3 Mart 1989"); fotoğraf tarihleriyle eşleşir.
  final String timelineDate;

  /// Son rulodan sonra: son karar ve kapanış.
  final Finale? finale;

  /// Baştan bilinen olaylar (örn. 12:30 soygun). Fotoğraflardan bulunan saatler bunlara eklenir.
  final List<({String tag, String title, String body})> timeline;

  int get totalReels => reelCount > reels.length ? reelCount : reels.length;

  Reel? reel(int number) {
    for (final r in reels) {
      if (r.number == number) return r;
    }
    return null;
  }

  Frame? frame(int reel, int frame) => this.reel(reel)?.frame(frame);

  Person? person(String id) {
    for (final p in people) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Kapak: ilk rulonun ilk fotoğrafı.
  String? get cover => reels.isEmpty || reels.first.frames.isEmpty
      ? null
      : reels.first.frames.first.photo.asset;
}

/// Dosyanın sonu: oyuncunun son kararı ve seçime göre kapanış.
class Finale {
  const Finale({
    required this.eyebrow,
    required this.intro,
    required this.question,
    required this.hint,
    required this.options,
    required this.epilogue,
  });
  final String eyebrow;
  final List<IntroLine> intro;
  final String question;
  final String hint;
  final List<FinaleOption> options;

  /// Her iki kapanışın ardından gelen son satırlar.
  final List<IntroLine> epilogue;

  FinaleOption? option(String? id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }
}

class FinaleOption {
  const FinaleOption(
      {required this.id,
      required this.text,
      required this.detail,
      required this.ending});
  final String id;
  final String text;
  final String detail;
  final List<IntroLine> ending;
}

/// Hikâye satırı nasıl görünür: düz anlatım, gazete kâğıdı ya da el yazısı mektup.
enum LineStyle {
  plain,
  paper,
  letter,

  /// Banyo edilir gibi beliren fotoğraf; metin altyazı olur.
  photo,
}

class IntroLine {
  const IntroLine(
      {required this.text,
      this.speaker,
      this.style = LineStyle.plain,
      this.sfx,
      this.image});
  final String text;

  /// [LineStyle.photo] için fotoğraf (paket içi tam yol).
  final String? image;

  /// Satır açılınca çalan ses (assets/audio/.wav), örn. "phone". Yoksa kâğıt sesi.
  final String? sfx;

  /// Konuşan kişinin kimliği; anlatıcıysa null.
  final String? speaker;

  final LineStyle style;
}

/// Kareler arasındaki kısa hikâye anı (bugünde geçer).
class Scene {
  const Scene(
      {required this.eyebrow, required this.title, required this.lines});
  final String eyebrow;
  final String title;
  final List<IntroLine> lines;
}

class Person {
  const Person(
      {required this.id,
      required this.name,
      required this.initial,
      required this.role,
      required this.known});
  final String id;
  final String name;
  final String initial;
  final String role;

  /// Dosya açılırken bilinen kişi mi (yoksa bir fotoğrafta tanışılır)?
  final bool known;
}

class Reel {
  const Reel(
      {required this.number,
      required this.title,
      required this.intro,
      required this.frames,
      this.question});
  final int number;
  final String title;
  final String intro;
  final List<Frame> frames;
  final ReelQuestion? question;

  Frame? frame(int number) {
    for (final f in frames) {
      if (f.number == number) return f;
    }
    return null;
  }
}

/// Rulo sonu sorusu (26). Oyuncunun cevabı deftere "teorin" olarak yazılır.
class ReelQuestion {
  const ReelQuestion({
    required this.text,
    required this.options,
    required this.truth,
    this.truthNote,
    this.replies = const {},
    this.outro = const [],
  });
  final String text;
  final List<({String id, String text})> options;

  /// Doğru seçeneğin kimliği. Oyuncuya final'e kadar söylenmez.
  final String truth;
  final String? truthNote;

  /// Seçilen cevaba verilen tepki (genelde Ayşe): seçenek kimliği → satır.
  final Map<String, IntroLine> replies;

  /// Cevaptan sonra gelen kapanış satırları (sonraki ruloya merak).
  final List<IntroLine> outro;
}

class Frame {
  const Frame(
      {required this.number,
      required this.puzzle,
      required this.photo,
      this.reaction,
      this.scene,
      this.search = false});
  final int number;
  final Puzzle puzzle;
  final PhotoSpec photo;

  /// İpucu bulununca birinin (genelde Ayşe) söylediği kısa söz.
  final IntroLine? reaction;

  /// Bu kareden sonra, sonraki bulmacadan önce gelen hikâye anı.
  final Scene? scene;

  /// true: oyuncu ayrıntıyı büyüteçle kendisi arar (rulo başına 3–4 kare).
  /// false: ayrıntı banyodan sonra kendiliğinden işaretlenir.
  final bool search;
}
