import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../entities/case_file.dart';
import '../entities/photo_spec.dart';

/// Dolapta henüz yazılmamış bir Dosya: Dosyalar ekranında "Yakında" kartı.
typedef UpcomingCase = ({int number, String title, String blurb});

/// DOMAIN · Hikâye içeriğine erişim. Açılışta bir kez yüklenir, sonra salt okunur.
/// Uygulaması: `data/repositories/content_repository_impl.dart`.
abstract interface class ContentRepository {
  /// Kimliğe göre bütün Dosyalar.
  Map<String, CaseFile> get cases;

  /// Dosyalar numara sırasıyla.
  List<CaseFile> get ordered;

  /// Henüz yazılmamış, "Yakında" gösterilecek Dosyalar.
  List<UpcomingCase> get upcoming;

  Frame? frame(String caseId, int reel, int frame);

  /// Karenin bulmacası; içerikte yoksa örnek bulmaca.
  Puzzle puzzleFor(String caseId, int reel, int frame);

  /// Karenin fotoğrafı ve ayrıntıları; içerikte yoksa örnek fotoğraf.
  PhotoSpec photoFor(String caseId, int reel, int frame);

  /// Bu rulodaki kare sayısı (içerik yoksa 10).
  int framesIn(String caseId, int reel);
}
