import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';

enum ReelIntroPhase {
  /// Makara boşta dönüyor.
  idle,

  /// "İlk kareyi banyo et"e basıldı: makara hızla sarıyor.
  winding,

  /// Sarma bitti: ilk bulmacaya geçilebilir.
  ready,
}

/// 16 · Rulo başlangıcı. Durum: makaranın hangi aşamada olduğu.
class ReelIntroViewModel extends Notifier<ReelIntroPhase> {
  /// Sarma animasyonu + kısa pay; sonra ilk bulmaca açılır.
  static const windDuration = Duration(milliseconds: 700);

  Timer? _go;

  @override
  ReelIntroPhase build() {
    ref.onDispose(() => _go?.cancel());
    return ReelIntroPhase.idle;
  }

  /// Hareket azaltılmışsa sarmadan doğrudan geçer.
  void start({required bool reduceMotion}) {
    if (state != ReelIntroPhase.idle) return;
    ref.read(gameAudioProvider).play(Sfx.reel);
    if (reduceMotion) {
      state = ReelIntroPhase.ready;
      return;
    }
    state = ReelIntroPhase.winding;
    _go = Timer(windDuration, () => state = ReelIntroPhase.ready);
  }
}

final reelIntroViewModelProvider =
    NotifierProvider.autoDispose<ReelIntroViewModel, ReelIntroPhase>(
        ReelIntroViewModel.new);
