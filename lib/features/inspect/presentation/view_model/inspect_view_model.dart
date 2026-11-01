import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/settings/settings.dart';
import '../../../content/domain/entities/photo_spec.dart';
import '../../../notebook/presentation/providers/notebook_store.dart';

/// Hangi fotoğraf ve oyuncu ayrıntıyı kendisi mi arıyor.
typedef InspectArgs = ({String caseId, int reel, int frame, bool search});

/// İnceleme ekranının çizdiği değişmez durum.
class InspectState {
  const InspectState({
    required this.spec,
    required this.revealed,
    required this.nudge,
    this.loupe,
  });

  final PhotoSpec spec;

  /// Ayrıntılar açığa çıktı mı (oyuncu buldu, "göster" dedi ya da arama karesi değil).
  final bool revealed;

  /// Arama karesinde bir süre bulunamazsa ayrıntının yeri hafifçe yanıp söner.
  final bool nudge;

  /// Büyütecin baktığı nokta (fotoğraf koordinatı, 300×400). Henüz dokunulmadıysa null.
  final Offset? loupe;

  List<Hotspot> get hotspots => spec.hotspots;
  bool get showsClues => revealed && hotspots.isNotEmpty;

  InspectState copyWith({bool? revealed, bool? nudge, Offset? loupe}) =>
      InspectState(
        spec: spec,
        revealed: revealed ?? this.revealed,
        nudge: nudge ?? this.nudge,
        loupe: loupe ?? this.loupe,
      );
}

/// 23 · Fotoğrafı incele: büyüteçle ayrıntıyı bul, deftere ekle.
class InspectViewModel extends Notifier<InspectState> {
  InspectViewModel(this.args);
  final InspectArgs args;

  static const nudgeAfter = Duration(seconds: 15);

  Timer? _nudgeTimer;

  @override
  InspectState build() {
    final spec = ref
        .read(contentRepositoryProvider)
        .photoFor(args.caseId, args.reel, args.frame);
    if (args.search) {
      _nudgeTimer = Timer(nudgeAfter, () {
        if (!state.revealed) state = state.copyWith(nudge: true);
      });
      ref.onDispose(() => _nudgeTimer?.cancel());
    }
    return InspectState(spec: spec, revealed: !args.search, nudge: false);
  }

  /// Büyüteç bu noktaya taşındı; bir ayrıntının üstündeyse bulunur.
  void probe(Offset point) {
    state = state.copyWith(loupe: point);
    if (state.revealed) return; // bir kez bulununca sabit kalır
    if (!state.hotspots.any((h) => h.contains(point))) return;
    if (ref.read(settingsProvider).vibration) HapticFeedback.mediumImpact();
    reveal();
  }

  /// Ayrıntıyı aç (bulundu ya da "Bulamadım, göster").
  void reveal() {
    _nudgeTimer?.cancel();
    ref.read(gameAudioProvider).play(Sfx.found);
    state = state.copyWith(revealed: true, nudge: false);
  }

  /// Ayrıntıları deftere yazar (zaten yazılı olanlar tekrar eklenmez).
  void addToNotebook() {
    final notebook = ref.read(notebookProvider.notifier);
    for (final h in state.hotspots) {
      notebook.add(NotebookClue(
        id: h.id,
        caseId: args.caseId,
        reel: args.reel,
        frame: args.frame,
        title: h.title,
        body: h.body,
        tag: h.tag,
        kind: h.kind,
        personId: h.personId,
      ));
    }
    ref.read(gameAudioProvider).play(Sfx.page);
  }
}

final inspectViewModelProvider = NotifierProvider.autoDispose
    .family<InspectViewModel, InspectState, InspectArgs>(InspectViewModel.new);

/// Bu fotoğrafın ayrıntılarının hepsi defterde mi?
final inspectInNotebookProvider =
    Provider.autoDispose.family<bool, InspectArgs>((ref, args) {
  final ids = ref.watch(inspectViewModelProvider(args)
      .select((s) => {for (final h in s.hotspots) h.id}));
  return ref.watch(notebookProvider
      .select((l) => ids.every((id) => l.any((c) => c.id == id))));
});
