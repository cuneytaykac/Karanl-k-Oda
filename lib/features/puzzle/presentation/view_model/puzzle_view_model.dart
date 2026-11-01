import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dev_flags.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/settings/settings.dart';
import '../../../ads/domain/entities/rewarded_ad_result.dart';
import '../../../ads/presentation/providers/ads_coordinator.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../domain/nonogram/board.dart';
import '../../domain/nonogram/cell_state.dart';
import '../../domain/nonogram/puzzle.dart';
import '../../domain/nonogram/session.dart';
import 'stroke_gate.dart';

/// Hangi kare: (dosya, rulo, kare).
typedef FrameKey = ({String caseId, int reel, int frame});

/// Ekranın çizdiği değişmez anlık görüntü.
class PuzzleState {
  const PuzzleState({
    required this.board,
    required this.tool,
    required this.hintsLeft,
    required this.canUndo,
    required this.solved,
    required this.showMistakes,
    required this.hintsUsed,
    this.solveTime,
    this.activeRow,
    this.activeCol,
    this.adHintAvailable = false,
    this.adLoading = false,
  });

  /// İpucu hakkı bitti ama reklam izleyerek ek ipucu alınabilir.
  final bool adHintAvailable;

  /// Reklam açılıyor ya da oynuyor (düğme o sırada bekler).
  final bool adLoading;

  /// Bu karede kullanılan ipucu sayısı.
  final int hintsUsed;

  /// Çözülünce dolar: ilk dokunuştan çözüme kadar geçen süre.
  final Duration? solveTime;

  final Board board;
  final Tool tool;
  final int hintsLeft;
  final bool canUndo;
  final bool solved;

  /// "Yanlışları göster" açıksa yanlış dolu kareler kırmızı gösterilir.
  final bool showMistakes;

  /// Sürükleme sırasında vurgulanan satır/sütun.
  final int? activeRow;
  final int? activeCol;

  Puzzle get puzzle => board.puzzle;
}

/// Bulmaca ekranını motora bağlar. Motor ([PuzzleSession]) saf Dart'tır;
/// bu sınıf yalnızca dokunuşları iletir ve her değişiklikte yeni görüntü yayınlar.
class PuzzleViewModel extends Notifier<PuzzleState> {
  PuzzleViewModel(this.key);

  final FrameKey key;
  late PuzzleSession _session;
  late bool _showMistakes;
  late int _startHints;
  bool _adLoading = false;
  int? _activeRow, _activeCol;
  final _gate = StrokeGate();

  // Süre ilk hamlede başlar (ekranı açıp bakmak süreye sayılmaz).
  final Stopwatch _clock = Stopwatch();
  Duration? _solveTime;

  @override
  PuzzleState build() {
    final settings = ref.read(settingsProvider);
    _showMistakes = settings.showMistakes;
    // Hak rulo başına herkese aynı; bu rulonun kullanılanı düşülür.
    const perReel = Settings.hintsPerReel;
    final hints = ref
            .read(progressProvider)[key.caseId]
            ?.hintsLeft(key.reel, perReel) ??
        perReel;
    _session = PuzzleSession(
      ref
          .read(contentRepositoryProvider)
          .puzzleFor(key.caseId, key.reel, key.frame),
      hintsLeft: hints,
    );
    _startHints = hints;
    return _snapshot();
  }

  PuzzleState _snapshot() => PuzzleState(
        board: _session.board,
        tool: _session.tool,
        hintsLeft: _session.hintsLeft,
        canUndo: _session.canUndo,
        solved: _session.isSolved,
        showMistakes: _showMistakes,
        hintsUsed: _startHints - _session.hintsLeft,
        solveTime: _solveTime,
        activeRow: _activeRow,
        activeCol: _activeCol,
        // Hak bitince reklamla ek ipucu her zaman alınabilir (sınır yok).
        adHintAvailable: !_session.isSolved && _session.hintsLeft == 0,
        adLoading: _adLoading,
      );

  void _emit() {
    if (_session.isSolved && _solveTime == null) {
      _clock.stop();
      _solveTime = _clock.elapsed;
      // Çözülen kare cihaza yazılır; uygulama kapansa da banyodan devam edilir.
      ref
          .read(progressProvider.notifier)
          .markSolved(key.caseId, key.reel, key.frame);
    }
    state = _snapshot();
  }

  void _startClock() {
    if (!_clock.isRunning && _solveTime == null) _clock.start();
  }

  // Çözüldükten sonra ızgara kilitlenir.
  bool get _locked => _session.isSolved;

  void setTool(Tool tool) {
    _session.tool = tool;
    _emit();
  }

  // ---- Parmak olayları (ızgaradan). İkinci parmak yok sayılır.

  bool touchDown(int pointer, int row, int col) =>
      _gate.claim(pointer) && startStroke(row, col);

  bool touchMove(int pointer, int row, int col) =>
      _gate.owns(pointer) && extendStroke(row, col);

  void touchUp(int pointer) {
    if (_gate.release(pointer)) endStroke();
  }

  /// Dokunma başladı. Hücre değiştiyse true döner (titreşim için).
  bool startStroke(int row, int col) {
    if (_locked) return false;
    _startClock();
    final before = _session.board;
    _session.startStroke(row, col);
    _activeRow = row;
    _activeCol = col;
    _emit();
    return _differs(before, _session.board);
  }

  /// Parmak hareket etti. Yeni hücre boyandıysa true döner.
  bool extendStroke(int row, int col) {
    if (_locked || !_session.isStroking) return false;
    final before = _session.board;
    _session.extendStroke(row, col);
    if (_activeRow == row &&
        _activeCol == col &&
        !_differs(before, _session.board)) {
      return false;
    }
    _activeRow = row;
    _activeCol = col;
    _emit();
    return _differs(before, _session.board);
  }

  void endStroke() {
    if (!_session.isStroking) return;
    _session.endStroke();
    _activeRow = _activeCol = null;
    _emit();
  }

  void undo() {
    if (_locked) return;
    _session.undo();
    _emit();
  }

  void clear() {
    if (_locked) return;
    _session.clear();
    _emit();
  }

  /// İpucu kullanıldıysa açılan satır, kullanılamadıysa null.
  int? useHint() {
    if (_locked) return null;
    _startClock();
    final row = _session.useHint();
    if (row != null) {
      ref.read(progressProvider.notifier).useHint(key.caseId, key.reel);
    }
    _emit();
    return row;
  }

  /// GELİŞTİRME: bulmacayı anında çözer ("Atla" düğmesi, bkz. [kDevSkipButton]).
  /// İpucu hakkına ve ilerlemedeki ipucu sayısına dokunmaz.
  void devSkip() {
    if (!kDevSkipButton || _locked) return;
    _startClock();
    final hintsLeft = _session.hintsLeft;
    while (!_session.isSolved) {
      _session.hintsLeft = 1;
      if (_session.useHint() == null) break;
    }
    _session.hintsLeft = hintsLeft;
    _emit();
  }

  /// Hak bitince: reklam izlenirse ek ipucu kazanılır ve hemen kullanılır.
  /// Reklam yüklenemezse oyuncu cezalandırılmaz; ipucu yine verilir.
  Future<AdHintOutcome> watchAdForHint() async {
    if (!state.adHintAvailable || _adLoading) return AdHintOutcome.unavailable;
    _adLoading = true;
    _emit();
    final result = await ref.read(adsCoordinatorProvider).showRewarded();
    if (!ref.mounted) return AdHintOutcome.unavailable;
    _adLoading = false;
    if (result == RewardedAdResult.dismissed) {
      _emit();
      return AdHintOutcome.dismissed;
    }
    ref.read(progressProvider.notifier).earnAdHint(key.caseId, key.reel);
    _session.hintsLeft += 1;
    _startHints += 1;
    useHint();
    return AdHintOutcome.granted;
  }

  static bool _differs(Board a, Board b) {
    if (identical(a, b)) return false;
    for (var i = 0; i < a.cells.length; i++) {
      if (a.cells[i] != b.cells[i]) return true;
    }
    return false;
  }
}

/// Reklamla ipucu isteğinin sonucu.
enum AdHintOutcome {
  /// İpucu verildi (reklam izlendi ya da reklam yoktu).
  granted,

  /// Oyuncu reklamı yarıda kapattı.
  dismissed,

  /// Şu an reklamla ipucu alınamaz (hâlâ hak var, bulmaca çözüldü ya da başka bir reklam açık).
  unavailable,
}

final puzzleViewModelProvider = NotifierProvider.autoDispose
    .family<PuzzleViewModel, PuzzleState, FrameKey>(PuzzleViewModel.new);
