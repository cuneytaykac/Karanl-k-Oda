import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/core/theme/theme.dart';
import 'package:karanlik_oda/features/onboarding/presentation/screen/tutorial_screen.dart';
import 'package:karanlik_oda/features/onboarding/presentation/view_model/tutorial_view_model.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/cell_state.dart';
import 'package:karanlik_oda/l10n/l10n.dart';

class _FixedSettings extends SettingsController {
  @override
  Settings build() => const Settings(vibration: false);
}

void main() {
  late ProviderContainer c;
  setUp(() {
    c = ProviderContainer(
        overrides: [settingsProvider.overrideWith(_FixedSettings.new)]);
    c.listen(tutorialViewModelProvider, (_, __) {});
  });
  tearDown(() => c.dispose());

  TutorialViewModel vm() => c.read(tutorialViewModelProvider.notifier);
  TutorialState state() => c.read(tutorialViewModelProvider);

  void drag(int pointer, (int, int) from, (int, int) to) {
    vm().touchDown(pointer, from.$1, from.$2);
    vm().touchMove(pointer, to.$1, to.$2);
    vm().touchUp(pointer);
  }

  test('adımlar oyuncu işi yapınca ilerler', () {
    expect(state().step, 0);
    expect(state().activeRow, 0);
    drag(1, (0, 0), (0, 4)); // üst satır
    expect(state().step, 1);
    expect(state().activeCol, 4);
    drag(1, (1, 4), (4, 4)); // sağ sütunun kalanı
    expect(state().step, 2);
    vm().setTool(Tool.cross);
    drag(1, (1, 2), (1, 2)); // ortaya ×
    expect(state().step, 3);
    expect(state().board.cellAt(1, 2), CellState.crossed);
  });

  test('ikinci parmak yok sayılır', () {
    vm().touchDown(1, 0, 0);
    vm().touchDown(2, 4, 0);
    vm().touchMove(2, 4, 4);
    expect(state().board.cellAt(4, 0), CellState.empty);
    expect(state().stroking, isTrue);
    vm().touchUp(1);
    expect(state().stroking, isFalse);
  });

  test('bulmaca çözülünce öğretici biter ve ızgara kilitlenir', () {
    for (final (r, row) in TutorialViewModel.rows.indexed) {
      for (var col = 0; col < row.length; col++) {
        if (row[col] == '#') drag(1, (r, col), (r, col));
      }
    }
    expect(state().done, isTrue);
    vm().touchDown(1, 1, 1);
    expect(state().board.cellAt(1, 1), CellState.empty);
  });

  testWidgets('ekran: el işareti görünür, çizerken gizlenir', (tester) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: koTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: TutorialScreen(onDone: () {}),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byIcon(Icons.touch_app_rounded), findsOneWidget);
    vm().touchDown(1, 0, 0);
    await tester.pump();
    expect(find.byIcon(Icons.touch_app_rounded), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
