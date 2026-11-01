import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';
import '../../../../core/di/providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// Hangi Dosyanın hangi rulosu.
typedef ReelKey = ({String caseId, int reel});

/// 26 · Rulo sonu sorusu. Durum: oyuncunun seçtiği teori (henüz seçmediyse null).
class ReelQuestionViewModel extends Notifier<String?> {
  ReelQuestionViewModel(this.key);
  final ReelKey key;

  /// Kapanış satırları sırayla belirir: ilki 1,1 sn sonra, sonra 0,9 sn arayla.
  static Duration outroDelay(int i) => Duration(milliseconds: 1100 + 900 * i);

  final _timers = <Timer>[];

  @override
  String? build() {
    ref.onDispose(() {
      for (final t in _timers) {
        t.cancel();
      }
    });
    // Daha önce cevaplandıysa seçili gelir.
    return ref.read(progressProvider)[key.caseId]?.theories[key.reel];
  }

  /// Teori bir kez verilir; deftere yazılır, kapanış satırlarının sesleri sırayla çalar.
  void choose(String optionId) {
    if (state != null) return;
    final audio = ref.read(gameAudioProvider);
    audio.play(Sfx.found);
    final outro = ref
            .read(contentRepositoryProvider)
            .cases[key.caseId]
            ?.reel(key.reel)
            ?.question
            ?.outro ??
        const [];
    for (var i = 0; i < outro.length; i++) {
      final sfx = Sfx.byName(outro[i].sfx);
      if (sfx != null) _timers.add(Timer(outroDelay(i), () => audio.play(sfx)));
    }
    state = optionId;
    ref
        .read(progressProvider.notifier)
        .setTheory(key.caseId, key.reel, optionId);
  }
}

final reelQuestionViewModelProvider = NotifierProvider.autoDispose
    .family<ReelQuestionViewModel, String?, ReelKey>(ReelQuestionViewModel.new);
