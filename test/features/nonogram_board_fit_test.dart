import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/theme/theme.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/board.dart';
import 'package:karanlik_oda/features/puzzle/presentation/widgets/nonogram_board.dart';

/// Hikâyedeki her bulmaca, bulmaca ekranındaki genişlikte taşmadan çizilmeli.
void main() {
  final file = CaseFileMapper.fromJson(
      jsonDecode(File('assets/case_files/wrong_man/case.json').readAsStringSync())
          as Map<String, dynamic>);

  // Ekran genişliği − bulmaca ekranının iki yan boşluğu.
  for (final screen in const [360.0, 390.0, 430.0]) {
    testWidgets('$screen genişlikte hiçbir kare taşmıyor', (tester) async {
      final width = screen - 2 * KoSpacing.l;
      for (final reel in file.reels) {
        for (final frame in reel.frames) {
          await tester.pumpWidget(MaterialApp(
            theme: koTheme(),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: width,
                  child: NonogramBoard(
                    board: Board.empty(frame.puzzle),
                    showMistakes: true,
                    onStrokeStart: (_, __, ___) {},
                    onStrokeExtend: (_, __, ___) {},
                    onStrokeEnd: (_) {},
                  ),
                ),
              ),
            ),
          ));
          expect(tester.takeException(), isNull,
              reason: 'Rulo ${reel.number} · Kare ${frame.number}');
        }
      }
    });
  }
}
