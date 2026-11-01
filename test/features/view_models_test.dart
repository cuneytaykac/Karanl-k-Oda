import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/audio/audio.dart';
import 'package:karanlik_oda/core/di/providers.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';
import 'package:karanlik_oda/features/content/data/repositories/content_repository_impl.dart';
import 'package:karanlik_oda/features/content/domain/entities/case_file.dart';
import 'package:karanlik_oda/features/finale/presentation/view_model/finale_view_model.dart';
import 'package:karanlik_oda/features/progress/presentation/providers/progress_providers.dart';
import 'package:karanlik_oda/features/question/presentation/view_model/reel_question_view_model.dart';
import 'package:karanlik_oda/features/splash/presentation/screen/splash_overlay.dart';
import 'package:karanlik_oda/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:karanlik_oda/features/story/presentation/view_model/story_view_model.dart';
import 'package:karanlik_oda/l10n/l10n.dart';

class _FixedSettings extends SettingsController {
  @override
  Settings build() => const Settings();
}

/// Çalınan sesleri kaydeder.
class _RecordingAudio implements GameAudio {
  final played = <Sfx>[];
  @override
  void play(Sfx sfx) => played.add(sfx);
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  final file = CaseFileMapper.fromJson(jsonDecode(
          File('assets/case_files/wrong_man/case.json').readAsStringSync())
      as Map<String, dynamic>);
  late _RecordingAudio audio;
  late ProviderContainer c;

  setUp(() {
    audio = _RecordingAudio();
    c = ProviderContainer(overrides: [
      contentRepositoryProvider
          .overrideWithValue(ContentRepositoryImpl({file.id: file})),
      gameAudioProvider.overrideWithValue(audio),
      settingsProvider.overrideWith(_FixedSettings.new),
    ]);
  });
  tearDown(() => c.dispose());

  group('Hikâye', () {
    const lines = [
      IntroLine(text: 'bir', sfx: 'phone'),
      IntroLine(text: 'iki'),
      IntroLine(text: 'üç'),
    ];
    const args = StoryArgs('test', lines);

    test('ilk satırın sesi açılışta çalar; dokundukça satır açılır', () {
      c.listen(storyViewModelProvider(args), (_, __) {});
      expect(c.read(storyViewModelProvider(args)), 1);
      expect(audio.played, [Sfx.phone]);
      final vm = c.read(storyViewModelProvider(args).notifier);
      vm.next();
      vm.next();
      vm.next(); // son satırdan sonra bir şey olmaz
      expect(c.read(storyViewModelProvider(args)), 3);
      expect(audio.played, [Sfx.phone, Sfx.page, Sfx.page]);
    });

    test('aynı kimlik aynı view model: satır listesi yeniden kurulsa da', () {
      c.listen(storyViewModelProvider(args), (_, __) {});
      c.read(storyViewModelProvider(args).notifier).next();
      final again = StoryArgs('test', List.of(lines));
      expect(c.read(storyViewModelProvider(again)), 2);
    });
  });

  group('Rulo sorusu', () {
    test('teori bir kez verilir ve ilerlemeye yazılır', () {
      const key = (caseId: 'wrong_man', reel: 1);
      c.listen(reelQuestionViewModelProvider(key), (_, __) {});
      final vm = c.read(reelQuestionViewModelProvider(key).notifier);
      final options = file.reel(1)!.question!.options;
      vm.choose(options.first.id);
      vm.choose(options.last.id);
      expect(c.read(reelQuestionViewModelProvider(key)), options.first.id);
      expect(
          c.read(progressProvider)['wrong_man']!.theories[1], options.first.id);
      expect(audio.played.first, Sfx.found);
    });
  });

  group('Son karar', () {
    test('seçim değişebilir; onaylanınca Dosya kapanır', () {
      c.listen(finaleViewModelProvider('wrong_man'), (_, __) {});
      final vm = c.read(finaleViewModelProvider('wrong_man').notifier);
      expect(vm.confirm(), isFalse, reason: 'seçim yok');
      final options = file.finale!.options;
      vm.select(options.first.id);
      vm.select(options.last.id);
      expect(vm.confirm(), isTrue);
      expect(c.read(progressProvider)['wrong_man']!.ending, options.last.id);
    });
  });

  group('Açılış sahnesi', () {
    Widget app() => UncontrolledProviderScope(
          container: c,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('tr'),
            home: SplashOverlay(),
          ),
        );

    testWidgets('tam süre oynar, sesler sırayla çalar', (tester) async {
      await tester.pumpWidget(app());
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(c.read(splashViewModelProvider(false)).done, isTrue);
      expect(audio.played, [Sfx.drip, Sfx.found]);
    });

    testWidgets('dokununca hızla biter', (tester) async {
      await tester.pumpWidget(app());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byType(SplashOverlay));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(c.read(splashViewModelProvider(false)).done, isTrue);
    });
  });
}
