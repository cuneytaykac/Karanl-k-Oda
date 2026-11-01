import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/core/theme/theme.dart';
import 'package:karanlik_oda/features/content/data/datasources/sample_content.dart';
import 'package:karanlik_oda/features/content/domain/entities/photo_spec.dart';
import 'package:karanlik_oda/features/inspect/presentation/screen/inspect_screen.dart';
import 'package:karanlik_oda/features/inspect/presentation/widgets/loupe_photo.dart';
import 'package:karanlik_oda/features/notebook/presentation/providers/notebook_store.dart';
import 'package:karanlik_oda/l10n/l10n.dart';

class _FixedSettings extends SettingsController {
  @override
  Settings build() => const Settings();
}

const _watch = Offset(205, 262); // saatin SVG koordinatı

void _phone(WidgetTester tester, [Size size = const Size(390, 844)]) {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

ProviderContainer _container() {
  final c = ProviderContainer(
      overrides: [settingsProvider.overrideWith(_FixedSettings.new)]);
  addTearDown(c.dispose);
  return c;
}

Future<void> _open(
  WidgetTester tester,
  ProviderContainer c, {
  VoidCallback? onNext,
  VoidCallback? onClose,
  Key? key,
}) async {
  await tester.pumpWidget(UncontrolledProviderScope(
    container: c,
    child: MaterialApp(
      theme: koTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: InspectScreen(
        key: key,
        caseId: 'wrong_man',
        reel: 2,
        frame: 4,
        onNext: onNext ?? () {},
        onClose: onClose ?? () {},
      ),
    ),
  ));
  await tester.pump();
}

/// SVG koordinatını (300×400) ekrandaki noktaya çevirir.
Offset _onScreen(WidgetTester tester, Offset svg) {
  final r = tester.getRect(find.byKey(LoupePhoto.photoKey));
  return r.topLeft + Offset(svg.dx / 300 * r.width, svg.dy / 400 * r.height);
}

Future<void> _sweep(WidgetTester tester, Offset fromSvg, Offset toSvg) async {
  final a = _onScreen(tester, fromSvg), b = _onScreen(tester, toSvg);
  final g = await tester.startGesture(a);
  for (var i = 1; i <= 10; i++) {
    await g.moveTo(Offset.lerp(a, b, i / 10)!);
    await tester.pump(const Duration(milliseconds: 16));
  }
  await g.up();
  await tester.pump(const Duration(milliseconds: 300));
}

/// Ağacı kapatıp animasyon kütüphanesinin sıfır süreli zamanlayıcılarını boşaltır.
/// [container] verilirse view model'ler de hemen kapanır (zamanlayıcıları iptal olur).
Future<void> _unmount(WidgetTester tester,
    [ProviderContainer? container]) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
  container?.dispose();
}

void main() {
  group('PhotoSpec', () {
    test('ayrıntılar fotoğrafın içinde', () {
      for (final h in SamplePuzzles.lakePhoto.hotspots) {
        expect(h.center.dx - h.radius, greaterThanOrEqualTo(0));
        expect(h.center.dy - h.radius, greaterThanOrEqualTo(0));
        expect(
            h.center.dx + h.radius, lessThanOrEqualTo(PhotoSpec.canvas.width));
        expect(
            h.center.dy + h.radius, lessThanOrEqualTo(PhotoSpec.canvas.height));
      }
    });

    test('contains: yarıçap içi evet, dışı hayır', () {
      final h = SamplePuzzles.lakePhoto.hotspots.single;
      expect(h.contains(_watch), isTrue);
      expect(h.contains(_watch + const Offset(15, 15)), isTrue);
      expect(h.contains(_watch + const Offset(30, 0)), isFalse);
    });

    test('ayrıntı kimlikleri tekil', () {
      final ids = SamplePuzzles.lakePhoto.hotspots.map((h) => h.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  testWidgets(
      'başta yönlendirme kartı; "Bulamadım, göster" ipucunu açar, kaçırmaz',
      (tester) async {
    _phone(tester);
    var next = 0;
    await _open(tester, _container(), onNext: () => next++);
    expect(find.text('Göl kıyısı'), findsOneWidget);
    expect(find.textContaining('Parmağınla dolaş'), findsOneWidget);
    expect(find.byKey(LoupePhoto.loupeKey), findsNothing,
        reason: 'büyüteç dokununca çıkar');
    expect(find.text('Bulamadım, göster'), findsOneWidget);
    await tester.tap(find.byKey(const Key('inspect-skip')));
    await tester.pump(const Duration(milliseconds: 600));
    expect(next, 0, reason: 'önce ipucu gösterilir');
    expect(find.text('Necati göldeydi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('inspect-add')));
    expect(next, 1);
    await _unmount(tester);
  });

  testWidgets('arama karesi değilse ayrıntı baştan işaretli ve tepki görünür',
      (tester) async {
    _phone(tester);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: _container(),
      child: MaterialApp(
        theme: koTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: InspectScreen(
          caseId: 'wrong_man',
          reel: 2,
          frame: 4,
          search: false,
          reaction: const Text('Ayşe konuşuyor'),
          onNext: () {},
          onClose: () {},
        ),
      ),
    ));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Necati göldeydi'), findsOneWidget);
    expect(find.text('Ayşe konuşuyor'), findsOneWidget);
    expect(find.byKey(const Key('inspect-skip')), findsNothing);
  });

  testWidgets('arama karesinde 15 sn bulunamazsa yer belirir', (tester) async {
    _phone(tester);
    await _open(tester, _container());
    final mark = find
        .byKey(ValueKey('mark-${SamplePuzzles.lakePhoto.hotspots.single.id}'));
    expect(mark, findsNothing);
    await tester.pump(const Duration(seconds: 16));
    await tester.pump();
    expect(mark, findsOneWidget);
    expect(find.textContaining('hafifçe parlıyor'), findsOneWidget);
    expect(find.text('Necati göldeydi'), findsNothing,
        reason: 'yer gösterilir ama ipucu kendin bulunca açılır');
    await _unmount(tester);
  });

  testWidgets('saate gelince ayrıntı bulunur ve Deftere ekle çıkar',
      (tester) async {
    _phone(tester);
    await _open(tester, _container());
    await _sweep(tester, const Offset(60, 120), _watch);
    expect(find.byKey(LoupePhoto.loupeKey), findsOneWidget);
    expect(find.text('Necati göldeydi'), findsOneWidget);
    expect(find.text('12:30'), findsOneWidget);
    expect(find.text('Deftere ekle · Kare 5'), findsOneWidget);
    expect(find.byKey(const Key('inspect-skip')), findsNothing);
  });

  testWidgets('yanlış yerde gezinmek bulmaz', (tester) async {
    _phone(tester);
    final c = _container();
    await _open(tester, c);
    await _sweep(tester, const Offset(30, 60), const Offset(80, 340));
    expect(find.text('Necati göldeydi'), findsNothing);
    expect(find.byKey(const Key('inspect-skip')), findsOneWidget);
    await _unmount(tester, c); // 15 sn'lik yönlendirme zamanlayıcısı kapanır
  });

  testWidgets('tek dokunuş da büyüteci oraya taşır', (tester) async {
    _phone(tester);
    await _open(tester, _container());
    await tester.tapAt(_onScreen(tester, _watch));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Necati göldeydi'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('büyüteç parmağın üstünde durur (parmak görüntüyü kapatmaz)',
      (tester) async {
    _phone(tester);
    final c = _container();
    await _open(tester, c);
    await _sweep(tester, const Offset(100, 200), const Offset(150, 300));
    final loupe = tester.getRect(find.byKey(LoupePhoto.loupeKey));
    final finger = _onScreen(tester, const Offset(150, 300));
    expect(loupe.center.dy, lessThan(finger.dy - 40));
    expect(loupe.center.dx, closeTo(finger.dx, 1));
    await _unmount(tester, c); // 15 sn'lik yönlendirme zamanlayıcısı kapanır
  });

  testWidgets('Deftere ekle deftere yazar; aynı ayrıntı iki kez eklenmez',
      (tester) async {
    _phone(tester);
    final c = _container();
    var next = 0;
    await _open(tester, c, onNext: () => next++);
    await _sweep(tester, const Offset(60, 120), _watch);
    await tester.tap(find.byKey(const Key('inspect-add')));
    await tester.pump();
    expect(next, 1);
    final clues = c.read(notebookProvider);
    expect(clues, hasLength(1));
    expect(clues.single.title, 'Necati göldeydi');
    expect(clues.single.tag, '12:30');
    expect(clues.single.source, 'R2 · K4');

    // Aynı kareyi yeniden açınca: düğme "Kare 5" olur, defter büyümez.
    await _open(tester, c, onNext: () => next++, key: const Key('again'));
    await _sweep(tester, const Offset(60, 120), _watch);
    expect(find.text('Kare 5'), findsOneWidget);
    await tester.tap(find.byKey(const Key('inspect-add')));
    await tester.pump();
    expect(c.read(notebookProvider), hasLength(1));
    expect(next, 2);
  });

  testWidgets('küçük ekranda (360×640) taşma yok ve fotoğraf yeterince büyük',
      (tester) async {
    _phone(tester, const Size(360, 640));
    await _open(tester, _container());
    await _sweep(tester, const Offset(60, 120), _watch);
    expect(tester.takeException(), isNull);
    final photo = tester.getRect(find.byKey(LoupePhoto.photoKey));
    expect(photo.width, greaterThanOrEqualTo(200));
    expect(photo.bottom, lessThanOrEqualTo(640));
  });
}
