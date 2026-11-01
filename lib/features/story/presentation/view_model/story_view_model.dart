import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';
import '../../../../core/settings/settings.dart';
import '../../../content/domain/entities/case_file.dart';

/// Hangi hikâye anı. Eşitlik yalnızca [id]'ye bakar: ekran yeniden kurulup satır
/// listesi yeni bir nesne olsa da aynı an aynı view model'i kullanır.
class StoryArgs {
  const StoryArgs(this.id, this.lines);
  final String id;
  final List<IntroLine> lines;

  @override
  bool operator ==(Object other) => other is StoryArgs && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Hikâye anı: satırlar tek tek açılır. Durum: kaç satır göründüğü.
class StoryViewModel extends Notifier<int> {
  StoryViewModel(this.args);
  final StoryArgs args;

  Timer? _secondBuzz;

  List<IntroLine> get _lines => args.lines;
  bool get allShown => state >= _lines.length;

  @override
  int build() {
    ref.onDispose(() => _secondBuzz?.cancel());
    // İlk satırın özel sesi varsa (örn. telefon) ekran açılınca çalar.
    if (_lines.isNotEmpty && _lines.first.sfx != null) _play(_lines.first);
    return 1;
  }

  /// Sonraki satırı aç.
  void next() {
    if (allShown) return;
    _play(_lines[state]);
    state++;
  }

  /// Satırın sesi varsa onu, yoksa kâğıt hışırtısını çalar. Telefon çalarken telefon da titrer.
  void _play(IntroLine line) {
    final special = Sfx.byName(line.sfx);
    ref.read(gameAudioProvider).play(special ?? Sfx.page);
    if ((special == Sfx.phone || special == Sfx.mobile) &&
        ref.read(settingsProvider).vibration) {
      HapticFeedback.heavyImpact();
      _secondBuzz?.cancel();
      _secondBuzz =
          Timer(const Duration(milliseconds: 180), HapticFeedback.heavyImpact);
    }
  }
}

final storyViewModelProvider = NotifierProvider.autoDispose
    .family<StoryViewModel, int, StoryArgs>(StoryViewModel.new);
