/// Bir Dosya'daki ilerleme. Saf veri: nasıl saklandığını bilmez.
///
/// Değişiklikler yeni bir nesne döndüren yöntemlerle yapılır; kurallar burada durur.
class CaseProgress {
  const CaseProgress({
    required this.caseId,
    this.reel = 1,
    this.frame = 1,
    this.solved = const {},
    this.clues = const [],
    this.theories = const {},
    this.notebookSeen = 0,
    this.hintsUsed = const {},
    this.adHints = const {},
    this.ending,
    this.updatedAt = 0,
  });

  final String caseId;

  /// Oyuncunun sıradaki karesi. [frame] rulodaki kare sayısını aşarsa rulo bitmiştir.
  final int reel;
  final int frame;

  /// Çözülmüş kareler: "rulo.kare".
  final Set<String> solved;

  /// Deftere eklenen ayrıntıların kimlikleri, eklenme sırasıyla.
  final List<String> clues;

  /// Rulo sonu sorularına verilen cevaplar: rulo → seçenek kimliği.
  final Map<int, String> theories;

  /// Rulo başına kullanılan ipucu: rulo → adet. Hak her rulonun başında yeniden dolar.
  final Map<int, int> hintsUsed;

  /// Rulo başına reklam izleyerek kazanılan ek ipucu: rulo → adet.
  final Map<int, int> adHints;

  /// Bu ruloda kalan ipucu: rulo başı hak + reklamla kazanılan − kullanılan.
  int hintsLeft(int reel, int perReel) =>
      (perReel + (adHints[reel] ?? 0) - (hintsUsed[reel] ?? 0))
          .clamp(0, 1 << 20);

  /// Finaldeki son karar (seçenek kimliği). Doluysa Dosya kapanmıştır.
  final String? ending;
  bool get isClosed => ending != null;

  /// Defter en son açıldığında içinde kaç kayıt (ipucu + teori) vardı.
  final int notebookSeen;

  /// Defterdeki kayıt sayısı; [notebookSeen]'den fazlaysa yeni bir şey var.
  int get notebookCount => clues.length + theories.length;
  bool get hasUnseenNotes => notebookCount > notebookSeen;

  /// En son ne zaman oynandı (ms). Banyo'da "devam et" için en yenisi seçilir.
  final int updatedAt;

  bool isSolved(int reel, int frame) => solved.contains('$reel.$frame');

  // ---- Kurallar: her biri yeni bir ilerleme döndürür; değişiklik yoksa null.

  /// Bulmaca çözüldü. Sıradaki kare bu karedir (banyo ve inceleme bekliyor).
  CaseProgress solve(int reel, int frame) =>
      copyWith(reel: reel, frame: frame, solved: {...solved, '$reel.$frame'});

  /// Kare bitti; sıradaki kare. Geriye gitmez: eski kareyi yeniden oynamak ilerlemeyi geri almaz.
  CaseProgress? advanceTo(int reel, int frame) {
    if (reel < this.reel || (reel == this.reel && frame < this.frame)) {
      return null;
    }
    return copyWith(reel: reel, frame: frame);
  }

  CaseProgress? addClue(String clueId) =>
      clues.contains(clueId) ? null : copyWith(clues: [...clues, clueId]);

  CaseProgress chooseTheory(int reel, String optionId) =>
      copyWith(theories: {...theories, reel: optionId});

  /// Bu rulonun bir ipucu hakkı kullanıldı. "En son oynanan"ı değiştirmez.
  CaseProgress useHint(int reel) => copyWith(
      hintsUsed: {...hintsUsed, reel: (hintsUsed[reel] ?? 0) + 1},
      touch: false);

  /// Reklam izlenerek bu rulo için bir ipucu kazanıldı.
  CaseProgress earnAdHint(int reel) => copyWith(
      adHints: {...adHints, reel: (adHints[reel] ?? 0) + 1}, touch: false);

  /// Son karar verildi: Dosya kapanır.
  CaseProgress close(String optionId) => copyWith(ending: optionId);

  /// Defter açıldı: içindekiler görüldü sayılır.
  CaseProgress? seeNotebook() => hasUnseenNotes
      ? copyWith(notebookSeen: notebookCount, touch: false)
      : null;

  CaseProgress copyWith({
    int? reel,
    int? frame,
    Set<String>? solved,
    List<String>? clues,
    Map<int, String>? theories,
    int? notebookSeen,
    Map<int, int>? hintsUsed,
    Map<int, int>? adHints,
    String? ending,
    bool touch = true,
  }) =>
      CaseProgress(
        caseId: caseId,
        reel: reel ?? this.reel,
        frame: frame ?? this.frame,
        solved: solved ?? this.solved,
        clues: clues ?? this.clues,
        theories: theories ?? this.theories,
        notebookSeen: notebookSeen ?? this.notebookSeen,
        hintsUsed: hintsUsed ?? this.hintsUsed,
        adHints: adHints ?? this.adHints,
        ending: ending ?? this.ending,
        // Defteri açmak "en son oynanan"ı değiştirmez.
        updatedAt: touch ? DateTime.now().millisecondsSinceEpoch : updatedAt,
      );
}
