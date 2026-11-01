import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/router/router.dart';
import 'package:karanlik_oda/core/router/routes.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/core/theme/theme.dart';
import 'package:karanlik_oda/features/content/data/datasources/sample_content.dart';
import 'package:karanlik_oda/features/develop/domain/entities/frame_result.dart';
import 'package:karanlik_oda/features/develop/presentation/screen/develop_screen.dart';
import 'package:karanlik_oda/features/develop/presentation/screen/negative_screen.dart';
import 'package:karanlik_oda/features/developing/presentation/screen/developing_screen.dart';
import 'package:karanlik_oda/features/inspect/presentation/screen/inspect_screen.dart';
import 'package:karanlik_oda/features/puzzle/presentation/screen/puzzle_screen.dart';
import 'package:karanlik_oda/l10n/l10n.dart';

class _FixedSettings extends SettingsController {
  @override
  Settings build() => const Settings();
}

void _phone(WidgetTester tester, [Size size = const Size(390, 844)]) {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Widget _app(Widget home, {bool reduceMotion = false}) => ProviderScope(
        child: MaterialApp(
      theme: koTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: reduceMotion
          ? Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: home,
              ),
            )
          : home,
    ));

void main() {
  group('FrameResult', () {
    test('süre biçimi', () {
      expect(
          const FrameResult(solveTime: Duration(seconds: 161), hintsUsed: 0)
              .timeLabel,
          '2:41');
      expect(
          const FrameResult(solveTime: Duration(seconds: 65), hintsUsed: 0)
              .timeLabel,
          '1:05');
      expect(
          const FrameResult(solveTime: Duration(minutes: 12), hintsUsed: 0)
              .timeLabel,
          '12:00');
      expect(const FrameResult(solveTime: null, hintsUsed: 0).timeLabel, '–');
    });
  });

  group('21 · Negatif', () {
    testWidgets('başlık, negatif, özet ve Banyo et', (tester) async {
      _phone(tester);
      var developed = 0;
      await tester.pumpWidget(_app(NegativeScreen(
        caseId: 'wrong_man',
        reel: 2,
        frame: 4,
        result:
            const FrameResult(solveTime: Duration(seconds: 161), hintsUsed: 1),
        onDevelop: () => developed++,
      )));
      expect(find.text('RULO 2 · KARE 4'), findsOneWidget);
      expect(find.text('Negatif hazır'), findsOneWidget);
      expect(find.byKey(const Key('negative-film')), findsOneWidget);
      expect(find.text('2:41'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('4/10'), findsOneWidget);
      await tester.tap(find.byKey(const Key('develop-button')));
      expect(developed, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sonuç verilmezse süre "–" ve küçük ekranda taşma yok',
        (tester) async {
      _phone(tester, const Size(360, 640));
      await tester.pumpWidget(_app(NegativeScreen(
          caseId: 'wrong_man', reel: 2, frame: 4, onDevelop: () {})));
      expect(find.text('–'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('22 · Banyo', () {
    Widget develop(VoidCallback onFinished) => DevelopScreen(
        photoAsset: SamplePuzzles.fishPhoto, onFinished: onFinished);

    testWidgets('tam süre: 3,2 sn + 0,5 sn duraklama sonra biter',
        (tester) async {
      _phone(tester);
      var done = 0;
      await tester.pumpWidget(_app(develop(() => done++)));
      expect(find.text('Fotoğraf beliriyor…'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 3000));
      expect(done, 0, reason: 'erken bitmemeli');
      await tester.pump(const Duration(milliseconds: 300)); // animasyon tamam
      expect(find.text('Hazır.'), findsOneWidget);
      expect(done, 0, reason: 'duraklama sürüyor');
      await tester.pump(const Duration(milliseconds: 600));
      expect(done, 1);
    });

    testWidgets('dokununca hızlanır', (tester) async {
      _phone(tester);
      var done = 0;
      await tester.pumpWidget(_app(develop(() => done++)));
      await tester.pump(const Duration(milliseconds: 800));
      await tester.tap(find.byKey(const Key('develop-tap-area')));
      await tester.pump(); // hızlanan animasyon bu karede başlar
      await tester.pump(
          const Duration(milliseconds: 500)); // ≤ 450 ms içinde tamamlanır
      expect(find.text('Hazır.'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(done, 1);
    });

    testWidgets('üst üste dokunmak da yalnızca bir kez bitirir',
        (tester) async {
      _phone(tester);
      var done = 0;
      await tester.pumpWidget(_app(develop(() => done++)));
      await tester.pump(const Duration(milliseconds: 200));
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byKey(const Key('develop-tap-area')));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pump(const Duration(seconds: 1)); // animasyon biter
      await tester.pump(const Duration(seconds: 1)); // duraklama biter
      expect(done, 1);
      await tester.pump(const Duration(seconds: 5));
      expect(done, 1, reason: 'ikinci kez çağrılmamalı');
    });

    testWidgets('Atla düğmesi yok', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(develop(() {})));
      expect(find.text('Atla'), findsNothing);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('hareketi azalt açıkken beklemeden biter', (tester) async {
      _phone(tester);
      var done = 0;
      await tester.pumpWidget(_app(develop(() => done++), reduceMotion: true));
      await tester.pump(const Duration(milliseconds: 600));
      expect(done, 1);
    });

    testWidgets('küçük ekranda taşma yok', (tester) async {
      _phone(tester, const Size(360, 640));
      await tester.pumpWidget(_app(develop(() {})));
      await tester.pump(const Duration(milliseconds: 1500));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  testWidgets('akış: Negatif → Banyo → İnceleme → sonraki kare → Banyo sekmesi',
      (tester) async {
    _phone(tester);
    final container = ProviderContainer(
        overrides: [settingsProvider.overrideWith(_FixedSettings.new)]);
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: koTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        routerConfig: router,
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(DevelopingScreen), findsOneWidget);

    router.push(
      Routes.negative('wrong_man', 2, 4),
      extra: const FrameResult(solveTime: Duration(seconds: 90), hintsUsed: 2),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NegativeScreen), findsOneWidget);
    expect(find.text('1:30'), findsOneWidget,
        reason: 'sonuç extra ile taşındı');

    await tester.tap(find.byKey(const Key('develop-button')));
    await tester.pump(); // yönlendirici yeni adresi çözer
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(DevelopScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('develop-tap-area')));
    await tester.pump(); // hızlanan banyo bu karede başlar
    await tester.pump(const Duration(seconds: 1)); // banyo biter
    await tester.pump(const Duration(seconds: 1)); // duraklama biter
    await tester.pumpAndSettle();
    expect(find.byType(InspectScreen), findsOneWidget);
    expect(find.text('Göl kıyısı'), findsOneWidget);

    // "Bulamadım, göster" → ipucu açılır; Deftere ekle → aynı rulonun sonraki karesi (5).
    await tester.tap(find.byKey(const Key('inspect-skip')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('inspect-add')));
    await tester.pumpAndSettle();
    expect(find.byType(PuzzleScreen), findsOneWidget);
    expect(find.text('Rulo 2 · Kare 5'), findsOneWidget);

    // Geri: zincir hep yer değiştirdiği için doğrudan Banyo sekmesi.
    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(DevelopingScreen), findsOneWidget,
        reason: 'geri tuşu çözülmüş bulmacaya değil Banyo\'ya döner');
    expect(find.byType(NegativeScreen), findsNothing);
    expect(find.byType(InspectScreen), findsNothing);
  });
}
