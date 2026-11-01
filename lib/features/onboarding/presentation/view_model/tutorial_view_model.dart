import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';
import '../../../../core/settings/settings.dart';
import '../../../puzzle/domain/nonogram/board.dart';
import '../../../puzzle/domain/nonogram/cell_state.dart';
import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../../../puzzle/domain/nonogram/session.dart';
import '../../../puzzle/presentation/view_model/stroke_gate.dart';

/// Öğretici ekranın çizdiği değişmez durum.
class TutorialState {
  const TutorialState({
    required this.board,
    required this.tool,
    required this.hintsLeft,
    required this.canUndo,
    required this.step,
    required this.stroking,
  });

  final Board board;
  final Tool tool;
  final int hintsLeft;
  final bool canUndo;

  /// 0: satır, 1: sütun, 2: ×, 3: kalanı; [TutorialViewModel.steps] ise bitti.
  final int step;

  /// Parmak ızgarada mı (el işareti o sırada gizlenir).
  final bool stroking;

  bool get done => step >= TutorialViewModel.steps;

  /// Adımın hedef satırı/sütunu vurgulanır: satır 0, sütun 4, satır 1.
  int? get activeRow => done ? null : (step == 0 ? 0 : (step == 2 ? 1 : null));
  int? get activeCol => done ? null : (step == 1 ? 4 : null);
}

/// İlk açılıştaki öğretici: 5×5 bir fotoğraf çerçevesi. Nermin Hanım'ın notu
/// dört adımda öğretir; her adım oyuncu o işi gerçekten yapınca ilerler.
class TutorialViewModel extends Notifier<TutorialState> {
  /// Çerçeve: dış kenar dolu, ortada tek nokta. Tahminsiz, tek çözümlü.
  static const rows = ['#####', '#...#', '#.#.#', '#...#', '#####'];
  static const steps = 4;

  late PuzzleSession _session;
  final _gate = StrokeGate();
  int _step = 0;

  @override
  TutorialState build() {
    _session = PuzzleSession(Puzzle.fromRows(rows), hintsLeft: 3);
    _step = 0;
    return _snapshot();
  }

  TutorialState _snapshot() => TutorialState(
        board: _session.board,
        tool: _session.tool,
        hintsLeft: _session.hintsLeft,
        canUndo: _session.canUndo,
        step: _step,
        stroking: _session.isStroking,
      );

  GameAudio get _audio => ref.read(gameAudioProvider);

  // ---- Parmak olayları (ızgaradan)

  void touchDown(int pointer, int row, int col) {
    if (state.done || !_gate.claim(pointer)) return;
    _change(() => _session.startStroke(row, col));
  }

  void touchMove(int pointer, int row, int col) {
    if (state.done || !_gate.owns(pointer) || !_session.isStroking) return;
    _change(() => _session.extendStroke(row, col));
  }

  void touchUp(int pointer) {
    if (!_gate.release(pointer) || !_session.isStroking) return;
    _session.endStroke();
    state = _snapshot();
  }

  // ---- Araç çubuğu

  void setTool(Tool tool) {
    _session.tool = tool;
    state = _snapshot();
  }

  void undo() {
    _session.undo();
    state = _snapshot();
  }

  void clear() {
    _session.clear();
    state = _snapshot();
  }

  void hint() {
    if (_session.useHint() == null) return;
    _feedback();
    _advance();
  }

  // ---- Kurallar

  /// Hamleyi uygular; kare değiştiyse ses/titreşim verir ve adımı ilerletir.
  void _change(void Function() move) {
    final before = _session.board.cells;
    move();
    if (!_sameCells(before, _session.board.cells)) _feedback();
    _advance();
  }

  void _feedback() {
    if (ref.read(settingsProvider).vibration) HapticFeedback.selectionClick();
    _audio.play(_session.tool == Tool.cross ? Sfx.cross : Sfx.tap);
  }

  /// Birden çok adım birden bitmiş olabilir (örn. oyuncu önden gitti).
  void _advance() {
    while (_step < steps && _stepDone(_step)) {
      _step++;
      if (_step < steps) _audio.play(Sfx.line);
    }
    if (_session.isSolved && _step < steps) _step = steps;
    if (_session.isSolved && state.step < steps) _audio.play(Sfx.solve);
    state = _snapshot();
  }

  bool _stepDone(int step) {
    final b = _session.board;
    return switch (step) {
      // en üst satır tamamen dolu
      0 => List.generate(5, (c) => b.cellAt(0, c))
          .every((x) => x == CellState.filled),
      // en sağ sütun tamamen dolu
      1 => List.generate(5, (r) => b.cellAt(r, 4))
          .every((x) => x == CellState.filled),
      // ikinci satırın ortasına en az bir ×
      2 => [1, 2, 3].any((c) => b.cellAt(1, c) == CellState.crossed),
      _ => _session.isSolved,
    };
  }

  static bool _sameCells(List<CellState> a, List<CellState> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

final tutorialViewModelProvider =
    NotifierProvider.autoDispose<TutorialViewModel, TutorialState>(
        TutorialViewModel.new);
