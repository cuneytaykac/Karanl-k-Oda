import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../../domain/entities/case_file.dart';
import '../../domain/entities/photo_spec.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/case_json_datasource.dart';
import '../datasources/sample_content.dart';
import '../models/case_file_mapper.dart';

/// DATA · [ContentRepository]'nin uygulaması: JSON'dan yüklenmiş Dosyalar, bellekte.
class ContentRepositoryImpl implements ContentRepository {
  const ContentRepositoryImpl(this.cases);

  /// Boş: testlerde ve içerik yüklenemezse. Ekranlar örnek içeriğe düşer.
  static const empty = ContentRepositoryImpl({});

  static Future<ContentRepositoryImpl> load(CaseJsonDataSource source) async {
    final files = [
      for (final json in await source.loadAll()) CaseFileMapper.fromJson(json)
    ];
    return ContentRepositoryImpl({for (final f in files) f.id: f});
  }

  @override
  final Map<String, CaseFile> cases;

  @override
  List<CaseFile> get ordered =>
      cases.values.toList()..sort((a, b) => a.number.compareTo(b.number));

  @override
  List<UpcomingCase> get upcoming => const [
        (
          number: 2,
          title: 'Oda 214',
          blurb: '1979 yazı. Bir otel misafiri iz bırakmadan kayboldu.'
        ),
        (
          number: 3,
          title: 'Göl Evi',
          blurb: 'Bir yaz boğulduğu sanıldı. Ceset hiç bulunmadı.'
        ),
      ];

  @override
  Frame? frame(String caseId, int reel, int frame) =>
      cases[caseId]?.frame(reel, frame);

  @override
  Puzzle puzzleFor(String caseId, int reel, int frame) =>
      this.frame(caseId, reel, frame)?.puzzle ??
      SamplePuzzles.puzzleFor(caseId, reel, frame);

  @override
  PhotoSpec photoFor(String caseId, int reel, int frame) =>
      this.frame(caseId, reel, frame)?.photo ??
      SamplePuzzles.photoSpecFor(caseId, reel, frame);

  @override
  int framesIn(String caseId, int reel) =>
      cases[caseId]?.reel(reel)?.frames.length ?? 10;
}
