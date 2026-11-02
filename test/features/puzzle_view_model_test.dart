import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/cell_state.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/puzzle.dart';
import 'package:karanlik_oda/features/puzzle/presentation/view_model/puzzle_view_model.dart';

class _FixedSettings extends SettingsController {
  _FixedSettings(this.value);
  final Settings value;

  @override
  Settings build() => value;
}

void main() {
  const key = (caseId: 'wrong_man', reel: 2, frame: 4);
  late ProviderContainer container;

  ProviderContainer make([Settings s = const Settings()]) {
    final c = ProviderContainer(overrides: [
      settingsProvider.overrideWith(() => _FixedSettings(s))
    ]);
    // autoDispose sağlayıcıyı test boyunca canlı tut.
    c.listen(puzzleViewModelProvider(key), (_, __) {});
    addTearDown(c.dispose);
    return c;
  }

  PuzzleState view() => container.read(puzzleViewModelProvider(key));
  PuzzleViewModel ctrl() =>
      container.read(puzzleViewModelProvider(key).notifier);

  setUp(() => container = make());

  test('başlangıç: boş tahta, doldurma aracı, rulo başına 3 ipucu', () {
    expect(view().board.filledCount, 0);
    expect(view().tool, Tool.fill);
    expect(view().hintsLeft, 3);
    expect(view().solved, isFalse);
    expect(view().mistakes, isEmpty);
  });

  test('yanlış kare kendiliğinden kırmızı olmaz (klasik nonogram)', () {
    final emptyCell = _firstEmptyCell(view().puzzle);
    ctrl().startStroke(emptyCell.$1, emptyCell.$2);
    ctrl().endStroke();
    expect(view().board.mistakes, isNotEmpty);
    expect(view().mistakes, isEmpty, reason: 'ipucu istenmedi');
  });

  test('ipucu önce hataları gösterir, hata yoksa satır açar', () {
    final emptyCell = _firstEmptyCell(view().puzzle);
    ctrl().startStroke(emptyCell.$1, emptyCell.$2);
    ctrl().endStroke();
    expect(ctrl().useHint(), HintKind.mistakes);
    expect(view().mistakes, hasLength(1));
    expect(view().hintsLeft, 2);
    // Oyuncu düzeltince kırmızı söner.
    ctrl().undo();
    expect(view().mistakes, isEmpty);
    expect(ctrl().useHint(), HintKind.row);
    expect(view().hintsLeft, 1);
  });

  test('sürükleme sırasında satır/sütun vurgulanır, bitince kalkar', () {
    ctrl().startStroke(4, 0);
    expect(view().activeRow, 4);
    ctrl().extendStroke(4, 5);
    expect(view().activeCol, 5);
    ctrl().endStroke();
    expect(view().activeRow, isNull);
    expect(view().activeCol, isNull);
  });

  test('titreşim sinyali yalnızca yeni hücre boyanınca', () {
    expect(ctrl().startStroke(4, 0), isTrue);
    expect(ctrl().extendStroke(4, 0), isFalse, reason: 'aynı hücre');
    expect(ctrl().extendStroke(4, 1), isTrue);
    expect(ctrl().extendStroke(4, 1), isFalse);
    ctrl().endStroke();
    ctrl().setTool(Tool.cross);
    expect(ctrl().startStroke(4, 0), isFalse, reason: 'dolu kareye × konmaz');
    ctrl().endStroke();
  });

  test('aynı kare için aynı kontrolcü, farklı kare için ayrı kontrolcü', () {
    ctrl().startStroke(1, 2);
    ctrl().endStroke();
    const other = (caseId: 'wrong_man', reel: 2, frame: 5);
    container.listen(puzzleViewModelProvider(other), (_, __) {});
    expect(container.read(puzzleViewModelProvider(other)).board.filledCount, 0);
    expect(view().board.filledCount, 1);
  });

  test('ipucuyla çözülünce kilitlenir', () {
    // 3 ipucu yetmez; kalan satırları elle çiz.
    while (ctrl().useHint() != null) {}
    final p = view().puzzle;
    for (var r = 0; r < p.height; r++) {
      for (var c = 0; c < p.width; c++) {
        if (p.isFilled(r, c) && view().board.cellAt(r, c) != CellState.filled) {
          ctrl().startStroke(r, c);
          ctrl().endStroke();
        }
      }
    }
    expect(view().solved, isTrue);
    expect(ctrl().startStroke(0, 0), isFalse);
    ctrl().undo();
    expect(view().solved, isTrue, reason: 'çözülmüş bulmaca geri alınamaz');
  });

  test('geliştirme "Atla" düğmesi bulmacayı çözer, ipucu hakkına dokunmaz', () {
    ctrl().devSkip();
    expect(view().solved, isTrue);
    expect(view().hintsLeft, 3);
  });
}

/// Çözümde boş olan ilk kare.
(int, int) _firstEmptyCell(Puzzle p) {
  for (var r = 0; r < p.height; r++) {
    for (var c = 0; c < p.width; c++) {
      if (!p.isFilled(r, c)) return (r, c);
    }
  }
  throw StateError('boş kare yok');
}
