import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/nonogram/board.dart';
import '../../domain/nonogram/cell_state.dart';

/// İpucu sayıları + ızgara. Ekran genişliğine göre kendini ölçekler
/// (10×10'dan 15×15'e kadar).
///
/// Dokunuşları [Listener] ile alır: oyun için hareket tanıma gecikmesi olmasın diye
/// GestureDetector yerine ham parmak olayları kullanılır. Her olay parmağın kimliğiyle
/// gelir; ikinci parmağı yok saymak view model'in işidir (bkz. [StrokeGate]).
class NonogramBoard extends StatelessWidget {
  const NonogramBoard({
    super.key,
    required this.board,
    required this.showMistakes,
    required this.onStrokeStart,
    required this.onStrokeExtend,
    required this.onStrokeEnd,
    this.activeRow,
    this.activeCol,
    this.semanticLabel,
    this.gridOverlay,
  });

  final Board board;
  final bool showMistakes;
  final int? activeRow;
  final int? activeCol;
  final String? semanticLabel;
  final void Function(int pointer, int row, int col) onStrokeStart;
  final void Function(int pointer, int row, int col) onStrokeExtend;
  final void Function(int pointer) onStrokeEnd;

  /// Izgaranın (yalnızca karelerin) üstüne çizilir; kare boyunu alır. Örn. öğreticideki el.
  final Widget Function(double cell)? gridOverlay;

  /// Testlerde ızgarayı bulmak için.
  static const gridKey = Key('nonogram-grid');

  static double _textWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  @override
  Widget build(BuildContext context) {
    final b = board;
    final p = b.puzzle;
    final maxColClues =
        p.colClues.map((c) => math.max(1, c.length)).reduce(math.max);
    // Telefonun yazı boyutu ayarı (erişilebilirlik) ipuçlarını büyütür; alanlar buna göre hesaplanır.
    final scaler = MediaQuery.textScalerOf(context);

    // Satır ipuçlarının genişliği, verilen yazı boyutunda: tahmin değil, gerçek ölçüm.
    double rowCluesWidth(double font) {
      final style = KoText.hintCount.copyWith(fontSize: font, height: 1.15);
      var widest = 0.0;
      for (final clue in p.rowClues) {
        var w = 0.0;
        for (final n in _labels(clue)) {
          w += _textWidth(n, style) + _rowGap;
        }
        widest = math.max(widest, w);
      }
      return math.max(28.0, (widest + _rowPadRight + 4).ceilToDouble());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Kare boyu ipucu genişliğine, ipucu genişliği yazı boyuna, yazı boyu kare boyuna bağlı:
        // iki tur yaklaşınca oturur.
        var font = scaler.scale(14);
        var rowClueW = 0.0, cell = 0.0;
        for (var i = 0; i < 2; i++) {
          rowClueW = rowCluesWidth(font);
          cell = ((constraints.maxWidth - rowClueW) / p.width)
              .floorToDouble()
              .clamp(16.0, 40.0);
          // Yazı satır yüksekliği kareyi aşmasın.
          font = math.min(
              scaler.scale((cell * 0.45).clamp(10.0, 14.0)), cell / 1.2);
        }
        rowClueW = rowCluesWidth(font);
        // Son yazı boyuyla ipucu sütunu biraz genişleyebilir: toplam genişlik
        // ekranı aşmasın diye kare boyu buna göre yeniden kısılır.
        final fits = ((constraints.maxWidth - rowClueW) / p.width).floorToDouble();
        if (fits >= 16 && cell > fits) cell = fits;
        final fontSize = font;
        final colClueH = math.max(22.0, maxColClues * fontSize * 1.15 + 4 + 6);
        final gridW = cell * p.width, gridH = cell * p.height;

        TextStyle clueStyle(bool done, bool active) =>
            KoText.hintCount.copyWith(
              fontSize: fontSize,
              height: 1.15,
              color: done
                  ? KoColor.textDisabled
                  : (active ? KoColor.redText : KoColor.text),
            );

        final overlay = gridOverlay;
        final content = Column(
          children: [
            // Sütun ipuçları
            Row(
              children: [
                SizedBox(width: rowClueW, height: colClueH),
                for (var c = 0; c < p.width; c++)
                  SizedBox(
                    width: cell,
                    height: colClueH,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (final n in _labels(p.colClues[c]))
                          Text(n,
                              textScaler: TextScaler.noScaling,
                              style: clueStyle(
                                  b.isColSatisfied(c), c == activeCol)),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                // Satır ipuçları
                Column(
                  children: [
                    for (var r = 0; r < p.height; r++)
                      SizedBox(
                        width: rowClueW,
                        height: cell,
                        child: Padding(
                          padding: const EdgeInsets.only(right: _rowPadRight),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (final n in _labels(p.rowClues[r])) ...[
                                Text(n,
                                    textScaler: TextScaler.noScaling,
                                    style: clueStyle(
                                        b.isRowSatisfied(r), r == activeRow)),
                                const SizedBox(width: _rowGap),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Izgara
                Semantics(
                  label: semanticLabel,
                  child: Listener(
                    key: NonogramBoard.gridKey,
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (e) {
                      final hit =
                          _cellAt(e.localPosition, cell, p.width, p.height);
                      if (hit == null) return;
                      onStrokeStart(e.pointer, hit.$1, hit.$2);
                    },
                    onPointerMove: (e) {
                      // Dışarı taşınca kenara sabitle (motor da sınırlar).
                      final r = (e.localPosition.dy / cell)
                          .floor()
                          .clamp(0, p.height - 1);
                      final c = (e.localPosition.dx / cell)
                          .floor()
                          .clamp(0, p.width - 1);
                      onStrokeExtend(e.pointer, r, c);
                    },
                    onPointerUp: (e) => onStrokeEnd(e.pointer),
                    onPointerCancel: (e) => onStrokeEnd(e.pointer),
                    child: CustomPaint(
                      size: Size(gridW, gridH),
                      painter: _GridPainter(
                        board: b,
                        cell: cell,
                        showMistakes: showMistakes,
                        activeRow: activeRow,
                        activeCol: activeCol,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

        return SizedBox(
          width: rowClueW + gridW,
          height: colClueH + gridH,
          child: overlay == null
              ? content
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    content,
                    Positioned(
                      left: rowClueW,
                      top: colClueH,
                      width: gridW,
                      height: gridH,
                      child: IgnorePointer(child: overlay(cell)),
                    ),
                  ],
                ),
        );
      },
    );
  }

  static (int, int)? _cellAt(Offset pos, double cell, int w, int h) {
    final r = (pos.dy / cell).floor(), c = (pos.dx / cell).floor();
    if (r < 0 || c < 0 || r >= h || c >= w) return null;
    return (r, c);
  }

  static const double _rowGap = 5;
  static const double _rowPadRight = 6;

  static List<String> _labels(List<int> clue) =>
      clue.isEmpty ? const ['0'] : [for (final n in clue) '$n'];
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.board,
    required this.cell,
    required this.showMistakes,
    this.activeRow,
    this.activeCol,
  });

  final Board board;
  final double cell;
  final bool showMistakes;
  final int? activeRow;
  final int? activeCol;

  static const _activeTint = Color(0xFFF6E2DB);

  @override
  void paint(Canvas canvas, Size size) {
    final p = board.puzzle;
    canvas.drawRect(Offset.zero & size, Paint()..color = KoColor.paper);

    // Sürüklenen satır/sütun vurgusu
    final tint = Paint()..color = _activeTint;
    if (activeRow != null) {
      canvas.drawRect(
          Rect.fromLTWH(0, activeRow! * cell, size.width, cell), tint);
    }
    if (activeCol != null) {
      canvas.drawRect(
          Rect.fromLTWH(activeCol! * cell, 0, cell, size.height), tint);
    }

    final ink = Paint()..color = KoColor.ink;
    final wrong = Paint()..color = KoColor.paperLabel;
    final cross = Paint()
      ..color = KoColor.paperLabel
      ..strokeWidth = math.max(1.4, cell * 0.07)
      ..strokeCap = StrokeCap.round;
    final wrongSet = showMistakes ? board.wrongFills.toSet() : const <int>{};
    final inset = cell * 0.3;

    for (var r = 0; r < p.height; r++) {
      for (var c = 0; c < p.width; c++) {
        final i = r * p.width + c;
        final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
        switch (board.cells[i]) {
          case CellState.filled:
            canvas.drawRect(
                rect.deflate(0.5), wrongSet.contains(i) ? wrong : ink);
          case CellState.crossed:
            canvas.drawLine(rect.topLeft + Offset(inset, inset),
                rect.bottomRight - Offset(inset, inset), cross);
            canvas.drawLine(rect.topRight + Offset(-inset, inset),
                rect.bottomLeft + Offset(inset, -inset), cross);
          case CellState.empty:
            break;
        }
      }
    }

    // Çizgiler: ince her hücre, kalın her 5 hücrede bir.
    final thin = Paint()
      ..color = KoColor.paperLine
      ..strokeWidth = 1;
    final thick = Paint()
      ..color = KoColor.paperLineThick
      ..strokeWidth = 2;
    for (var c = 1; c < p.width; c++) {
      final x = c * cell;
      canvas.drawLine(
          Offset(x, 0), Offset(x, size.height), c % 5 == 0 ? thick : thin);
    }
    for (var r = 1; r < p.height; r++) {
      final y = r * cell;
      canvas.drawLine(
          Offset(0, y), Offset(size.width, y), r % 5 == 0 ? thick : thin);
    }
    canvas.drawRect(
      (Offset.zero & size).deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = KoColor.paperLineThick,
    );
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      !identical(old.board, board) ||
      old.cell != cell ||
      old.showMistakes != showMistakes ||
      old.activeRow != activeRow ||
      old.activeCol != activeCol;
}
