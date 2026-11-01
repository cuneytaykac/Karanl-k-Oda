import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// Son karar. Durum: oyuncunun işaretlediği seçenek (onaylanana kadar değişebilir).
class FinaleViewModel extends Notifier<String?> {
  FinaleViewModel(this.caseId);
  final String caseId;

  @override
  String? build() => null;

  void select(String optionId) {
    ref.read(gameAudioProvider).play(Sfx.page);
    state = optionId;
  }

  /// Seçim kesinleşir: Dosya kapanır. Seçili bir şey yoksa false.
  bool confirm() {
    final choice = state;
    if (choice == null) return false;
    ref.read(gameAudioProvider).play(Sfx.found);
    ref.read(progressProvider.notifier).setEnding(caseId, choice);
    return true;
  }
}

final finaleViewModelProvider = NotifierProvider.autoDispose
    .family<FinaleViewModel, String?, String>(FinaleViewModel.new);
