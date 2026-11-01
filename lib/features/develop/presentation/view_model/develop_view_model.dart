import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';

/// Banyo ekranının durumu.
class DevelopState {
  const DevelopState({required this.progress, required this.finished});

  /// 0–1: fotoğrafın ne kadar belirdiği.
  final double progress;

  /// Fotoğraf belirdi ve kısa duraklama da bitti: sonraki ekrana geçilebilir.
  final bool finished;

  bool get developed => progress >= 1;
}

/// 22 · Banyo: fotoğraf tepside yavaşça belirir; dokunmak kalanı hızlandırır.
///
/// İlerlemeyi kendi [Ticker]'ı ile sayar: ekran durumsuz kalır, hızlandırma da
/// tek yerde hesaplanır.
class DevelopViewModel extends Notifier<DevelopState> {
  DevelopViewModel(this.reduceMotion);

  /// Telefonda "hareketi azalt" açıksa bekletmeden son hâl gösterilir.
  final bool reduceMotion;

  static const fullDuration = Duration(milliseconds: 3200);
  static const fastForward = Duration(milliseconds: 450);

  /// Fotoğraf tamamen belirdikten sonra geçişten önceki kısa duraklama.
  static const holdAfter = Duration(milliseconds: 500);

  Ticker? _ticker;
  Timer? _hold;
  Duration _now = Duration.zero;

  // Şu anki bölüm: [_from] değerinden 1'e, [_span] sürede, [_curve] eğrisiyle.
  Duration _start = Duration.zero;
  double _from = 0;
  Duration _span = fullDuration;
  Curve _curve = Curves.linear;

  @override
  DevelopState build() {
    ref.onDispose(() {
      _ticker?.dispose();
      _hold?.cancel();
    });
    ref.read(gameAudioProvider).play(Sfx.develop);
    if (reduceMotion) {
      _holdThenFinish();
      return const DevelopState(progress: 1, finished: false);
    }
    _ticker = Ticker(_tick)..start();
    return const DevelopState(progress: 0, finished: false);
  }

  void _tick(Duration elapsed) {
    _now = elapsed;
    final t = _span == Duration.zero
        ? 1.0
        : ((elapsed - _start).inMicroseconds / _span.inMicroseconds)
            .clamp(0.0, 1.0);
    final progress = _from + (1 - _from) * _curve.transform(t);
    state = DevelopState(progress: progress, finished: false);
    if (t >= 1) {
      _ticker?.stop();
      _holdThenFinish();
    }
  }

  void _holdThenFinish() {
    _hold = Timer(holdAfter, () {
      state = const DevelopState(progress: 1, finished: true);
    });
  }

  /// Ekrana dokunuldu: kalan kısım [fastForward] oranında hızla biter.
  void speedUp() {
    if (state.developed || _ticker == null || !_ticker!.isActive) return;
    _from = state.progress;
    _start = _now;
    _span = fastForward * (1 - _from);
    _curve = Curves.easeOut;
  }
}

final developViewModelProvider = NotifierProvider.autoDispose
    .family<DevelopViewModel, DevelopState, bool>(DevelopViewModel.new);
