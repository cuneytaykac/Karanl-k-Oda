import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/features/content/data/datasources/sample_content.dart';
import 'package:karanlik_oda/features/develop/domain/entities/frame_result.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/cell_state.dart';
import 'package:karanlik_oda/features/puzzle/presentation/screen/puzzle_screen.dart';
import 'package:karanlik_oda/features/puzzle/presentation/view_model/puzzle_view_model.dart';
import 'package:karanlik_oda/features/puzzle/presentation/widgets/nonogram_board.dart';
import 'package:karanlik_oda/l10n/l10n.dart';

class _FixedSettings extends SettingsController {
  _FixedSettings(this.value);
  final Settings value;

  @override
  Settings build() => value;
}

const _key = (caseId: 'wrong_man', reel: 2, frame: 4);

Future<void> _open(
  WidgetTester tester, {
  Settings settings = const Settings(),
  Size size = const Size(390, 844),
  void Function(FrameResult)? onContinue,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(() => _FixedSettings(settings))
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: PuzzleScreen(
            caseId: 'wrong_man', reel: 2, frame: 4, onContinue: onContinue),
      ),
    ),
  );
  await tester.pump();
}

PuzzleState _view(WidgetTester tester) {
  final container =
      ProviderScope.containerOf(tester.element(find.byType(PuzzleScreen)));
  return container.read(puzzleViewModelProvider(_key));
}

/// (satır, sütun) hücresinin ekrandaki merkezi.
Offset _cell(WidgetTester tester, int r, int c) {
  final rect = tester.getRect(find.byKey(NonogramBoard.gridKey));
  final size = rect.width / 10;
  return rect.topLeft + Offset((c + 0.5) * size, (r + 0.5) * size);
}

Future<void> _drag(WidgetTester tester, (int, int) from, (int, int) to) async {
  final g = await tester.startGesture(_cell(tester, from.$1, from.$2));
  await tester.pump();
  final end = _cell(tester, to.$1, to.$2);
  final start = _cell(tester, from.$1, from.$2);
  for (var i = 1; i <= 6; i++) {
    await g.moveTo(Offset.lerp(start, end, i / 6)!);
    await tester.pump();
  }
  await g.up();
  await tester.pump();
}

void main() {
  testWidgets('ekran açılıyor: başlık, boyut, ipucu sayıları', (tester) async {
    await _open(tester);
    expect(find.text('Rulo 2 · Kare 4'), findsOneWidget);
    expect(find.text('10×10'), findsOneWidget);
    expect(find.text('10'), findsNWidgets(2)); // 5. ve 6. satır
    expect(find.text('İpucu · 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dokununca hücre dolar, tekrar dokununca boşalır',
      (tester) async {
    await _open(tester);
    await tester.tapAt(_cell(tester, 1, 2));
    await tester.pump();
    expect(_view(tester).board.cellAt(1, 2), CellState.filled);
    await tester.tapAt(_cell(tester, 1, 2));
    await tester.pump();
    expect(_view(tester).board.cellAt(1, 2), CellState.empty);
  });

  testWidgets('sürükleyince satır dolar ve tamamlanan satırın sayısı söner',
      (tester) async {
    await _open(tester);
    await _drag(tester, (4, 0), (4, 9));
    final v = _view(tester);
    for (var c = 0; c < 10; c++) {
      expect(v.board.cellAt(4, c), CellState.filled, reason: 'sütun $c');
    }
    expect(v.board.isRowSatisfied(4), isTrue);
    expect(v.activeRow, isNull, reason: 'parmak kalkınca vurgu kalkar');
  });

  testWidgets('çapraz sürükleme ilk eksende kalır', (tester) async {
    await _open(tester);
    await _drag(tester, (3, 3), (6, 8));
    final v = _view(tester);
    // Yatay hareket büyük olduğu için yalnızca 3. satır boyanır.
    expect(v.board.cellAt(3, 8), CellState.filled);
    expect(v.board.cellAt(6, 8), CellState.empty);
    expect(v.board.cellAt(4, 3), CellState.empty);
  });

  testWidgets('İşaretle aracı × koyar, Geri al geri alır', (tester) async {
    await _open(tester);
    await tester.tap(find.text('×  İşaretle'));
    await tester.pump();
    await tester.tapAt(_cell(tester, 0, 0));
    await tester.pump();
    expect(_view(tester).board.cellAt(0, 0), CellState.crossed);
    await tester.tap(find.text('Geri al'));
    await tester.pump();
    expect(_view(tester).board.cellAt(0, 0), CellState.empty);
  });

  testWidgets('ipucu satır açar, bitince uyarı çıkar', (tester) async {
    await _open(tester);
    for (final left in [3, 2, 1]) {
      await tester.tap(find.text('İpucu · $left'));
      await tester.pump();
    }
    expect(find.text('İpucu · 0'), findsOneWidget);
    expect(_view(tester).board.isRowCorrect(1), isTrue);
    await tester.tap(find.text('İpucu · 0'));
    await tester.pump();
    expect(find.text('İpucun kalmadı. Kendin çözebilirsin.'), findsOneWidget);
  });

  testWidgets('3 ipucu; yanlış kare işaretlenir', (tester) async {
    await _open(tester);
    expect(find.text('İpucu · 3'), findsOneWidget);
    await tester.tapAt(_cell(tester, 0, 0)); // çözümde boş
    await tester.pump();
    final v = _view(tester);
    expect(v.showMistakes, isTrue);
    expect(v.board.wrongFills, [0]);
  });

  testWidgets('"Yanlışları göster" kapalıysa yanlış kare işaretlenmez',
      (tester) async {
    await _open(tester, settings: const Settings(showMistakes: false));
    await tester.tapAt(_cell(tester, 0, 0)); // çözümde boş
    await tester.pump();
    expect(_view(tester).showMistakes, isFalse);
  });

  testWidgets('balığı çizince çözülür, ızgara kilitlenir, Devam sonucu taşır',
      (tester) async {
    FrameResult? result;
    await _open(tester, onContinue: (r) => result = r);
    final p = SamplePuzzles.fish;
    for (var r = 0; r < p.height; r++) {
      var c = 0;
      while (c < p.width) {
        if (!p.isFilled(r, c)) {
          c++;
          continue;
        }
        final start = c;
        while (c < p.width && p.isFilled(r, c)) {
          c++;
        }
        if (start == c - 1) {
          await tester.tapAt(_cell(tester, r, start));
          await tester.pump();
        } else {
          await _drag(tester, (r, start), (r, c - 1));
        }
      }
    }
    await tester.pump(const Duration(milliseconds: 300));
    expect(_view(tester).solved, isTrue);
    expect(find.text('Negatif hazır.'), findsOneWidget);
    expect(find.text('Geri al'), findsNothing, reason: 'araç çubuğu kalkar');

    // Çözüldükten sonra dokunuş tahtayı değiştirmez.
    final before = _view(tester).board.filledCount;
    await tester.tapAt(_cell(tester, 0, 0));
    await tester.pump();
    expect(_view(tester).board.filledCount, before);

    await tester.tap(find.text('Devam'));
    await tester.pump();
    expect(result, isNotNull);
    expect(result!.hintsUsed, 0);
    expect(result!.solveTime, isNotNull);
  });

  testWidgets('küçük telefonda (360×640) taşma yok', (tester) async {
    await _open(tester, size: const Size(360, 640));
    expect(tester.takeException(), isNull);
    final grid = tester.getRect(find.byKey(NonogramBoard.gridKey));
    expect(grid.right, lessThanOrEqualTo(360));
    // Hücreler parmakla dokunulabilecek büyüklükte (en az 24 pt).
    expect(grid.width / 10, greaterThanOrEqualTo(24));
  });

  testWidgets('ikinci parmak yok sayılır', (tester) async {
    await _open(tester);
    final g1 = await tester.startGesture(_cell(tester, 4, 0));
    await tester.pump();
    final g2 = await tester.startGesture(_cell(tester, 8, 8), pointer: 7);
    await tester.pump();
    await g2.up();
    await g1.up();
    await tester.pump();
    final v = _view(tester);
    expect(v.board.cellAt(4, 0), CellState.filled);
    expect(v.board.cellAt(8, 8), CellState.empty);
  });
}
