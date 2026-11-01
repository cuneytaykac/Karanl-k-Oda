import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/widgets/ko_photo.dart';
import 'package:karanlik_oda/features/puzzle/presentation/screen/puzzle_screen.dart';

/// assets/case_files altındaki bütün SVG fotoğraflar.
List<File> allPhotos() => Directory('assets/case_files')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.svg'))
    .toList();

void main() {
  test('en az bir fotoğraf var', () {
    expect(allPhotos(), isNotEmpty);
  });

  group('her fotoğraf kurallara uyuyor', () {
    for (final f in allPhotos()) {
      final name = f.uri.pathSegments.last;
      final svg = f.readAsStringSync();

      test('$name: 3:4 viewBox (300×400)', () {
        expect(svg, contains('viewBox="0 0 300 400"'));
      });

      test('$name: flutter_svg\'nin desteklemediği öğeler yok', () {
        // filter/mask/pattern/style/foreignObject Flutter'da görünmez ya da hatalı çizilir.
        for (final tag in [
          '<filter',
          '<mask',
          '<pattern',
          '<style',
          '<foreignObject',
          '<image',
          'href="http'
        ]) {
          expect(svg.contains(tag), isFalse, reason: '$name içinde $tag var');
        }
      });

      test('$name: pubspec.yaml bu klasörü asset olarak tanıyor', () {
        final dir = f.parent.path.replaceAll('\\', '/');
        final pubspec = File('pubspec.yaml').readAsStringSync();
        expect(pubspec, contains('- $dir/'),
            reason: '$dir/ pubspec.yaml assets listesinde yok');
      });

      testWidgets('$name: flutter_svg ile hatasız çözümleniyor',
          (tester) async {
        final info = await tester
            .runAsync(() => vg.loadPicture(SvgStringLoader(svg), null));
        expect(info, isNotNull);
        expect(info!.size, const Size(300, 400));
        info.picture.dispose();
      });
    }
  });

  testWidgets('KoPhoto asset\'i paketten yükleyip çiziyor', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
            body: Center(
                child: KoPhoto(asset: PuzzleScreen.previewPhoto, width: 240))),
      ),
    );
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(KoPhoto));
    expect(size.width, 240);
    // 240 genişlik: 2×8 çerçeve + 224×(4/3) foto = 314.67
    expect(size.height, closeTo(314.67, 1));
  });
}
