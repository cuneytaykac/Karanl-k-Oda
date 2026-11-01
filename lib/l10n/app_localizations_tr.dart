// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Karanlık Oda';

  @override
  String get navDeveloping => 'Banyo';

  @override
  String get navCaseFiles => 'Dosyalar';

  @override
  String get navNotebook => 'Defter';

  @override
  String pageNotFound(String uri) {
    return 'Sayfa bulunamadı: $uri';
  }

  @override
  String get caseFilesEyebrow => 'TESLİM EDİLMEYENLER';

  @override
  String get caseFilesTitle => 'Dosyalar';

  @override
  String get caseFilesPlaceholder => 'Dosya listesi burada olacak.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get back => 'Geri';

  @override
  String get sectionGame => 'OYUN';

  @override
  String get showMistakes => 'Yanlışları göster';

  @override
  String get showMistakesSubtitle => 'Yanlış doldurulan kare kırmızı yanar';

  @override
  String hintsPerReel(int count) {
    return 'Her rulo başında $count ipucu.';
  }

  @override
  String get stuckHelp => 'Takılma yardımı';

  @override
  String get stuckHelpSubtitle => '2 dk ilerleme yoksa ücretsiz ipucu';

  @override
  String get sectionSound => 'SES VE TİTREŞİM';

  @override
  String get music => 'Müzik';

  @override
  String get sfx => 'Efekt sesleri';

  @override
  String get vibration => 'Titreşim';

  @override
  String get sectionNotifications => 'BİLDİRİM';

  @override
  String get newCaseNotification => 'Yeni dosya bildirimi';

  @override
  String get newCaseNotificationSubtitle =>
      'Dolaba yeni film gelince haber ver';

  @override
  String get puzzleBackLabel => 'Banyoya dön';

  @override
  String puzzleTitle(int reel, int frame) {
    return 'Rulo $reel · Kare $frame';
  }

  @override
  String get puzzleGridPlaceholder => 'Izgara · Aşama 1';

  @override
  String get brandDark => 'KARANLIK ';

  @override
  String get brandRoom => 'ODA';

  @override
  String get developingHeadline => 'Dolap seni bekliyor.';

  @override
  String get developingSubtitle =>
      'Nermin Hanım’ın teslim etmediği filmlerden birini seç.';

  @override
  String get openCaseFiles => 'Dosyalara bak';

  @override
  String get debugPuzzle => 'Deneme bulmacası';

  @override
  String get notebookEyebrow => 'SORUŞTURMA';

  @override
  String get notebookTitle => 'Defter';

  @override
  String get notebookEmptyTitle => 'Defterin boş';

  @override
  String get notebookEmptyBody =>
      'Bir dosya açtığında bulduğun her şey buraya kendiliğinden yazılır.';

  @override
  String get goToCaseFiles => 'Dosyalara git';

  @override
  String get puzzleToolFill => 'Doldur';

  @override
  String get puzzleToolCross => 'İşaretle';

  @override
  String get puzzleUndo => 'Geri al';

  @override
  String puzzleHint(int count) {
    return 'İpucu · $count';
  }

  @override
  String get puzzleClear => 'Temizle';

  @override
  String get puzzleHintAd => '+1 İpucu';

  @override
  String get puzzleAdDismissed => 'Reklam yarıda kaldı; ipucu verilmedi.';

  @override
  String get puzzleNoHints => 'İpucun kalmadı. Kendin çözebilirsin.';

  @override
  String get puzzleSolvedTitle => 'Negatif hazır.';

  @override
  String get puzzleSolvedBody => 'Bir şey belirdi.';

  @override
  String get puzzleSeePhoto => 'Fotoğrafı gör';

  @override
  String get puzzleHelp => 'Dokun ya da sürükle. Yanlış kare cezasız.';

  @override
  String puzzleGridLabel(int width, int height) {
    return '$width×$height bulmaca ızgarası';
  }

  @override
  String get puzzleContinue => 'Devam';

  @override
  String negativeEyebrow(int reel, int frame) {
    return 'RULO $reel · KARE $frame';
  }

  @override
  String get negativeTitle => 'Negatif hazır';

  @override
  String get negativeImageLabel => 'Tamamlanmış film negatifi';

  @override
  String get negativeHint => 'Fotoğrafta ne olduğunu ancak banyoda göreceksin.';

  @override
  String get statTime => 'süre';

  @override
  String get statHints => 'ipucu';

  @override
  String get statFrame => 'rulo';

  @override
  String get developButton => 'Banyo et';

  @override
  String get skip => 'Atla';

  @override
  String get developingSemantics => 'Banyo tepsisinde beliren fotoğraf';

  @override
  String get developingProgress => 'Fotoğraf beliriyor…';

  @override
  String get developingDone => 'Hazır.';

  @override
  String get developingTapToSpeed => 'Hızlandırmak için dokun';

  @override
  String get developedPhotoLabel => 'Banyo edilmiş fotoğraf';

  @override
  String get done => 'Tamam';

  @override
  String get inspectHint =>
      'Fotoğrafta bir ayrıntı var. Parmağınla dolaş; büyüteç bir şeye takılınca anlarsın.';

  @override
  String get inspectSkip => 'Şimdilik geç';

  @override
  String inspectAddToNotebook(int frame) {
    return 'Deftere ekle · Kare $frame';
  }

  @override
  String inspectNextFrame(int frame) {
    return 'Kare $frame';
  }

  @override
  String get inspectPhotoLabel =>
      'İncelenen fotoğraf. Büyüteçle gezmek için parmağını sürükle.';

  @override
  String caseNumber(int number) {
    return 'DOSYA $number';
  }

  @override
  String get caseStatusNew => 'YENİ';

  @override
  String get caseComingSoon => 'Yakında';

  @override
  String casePeopleCount(int count) {
    return 'KİŞİLER · $count';
  }

  @override
  String get caseOpen => 'Dosyayı aç';

  @override
  String get caseOneAtATime =>
      'Bir seferde bir dosya. Yarıda bırakırsan kaldığın yerden sürer.';

  @override
  String get caseOpenBag => 'Torbayı aç';

  @override
  String get tapToContinue => 'Devam etmek için dokun';

  @override
  String reelOf(int reel, int total) {
    return 'RULO $reel / $total';
  }

  @override
  String reelFrames(int count) {
    return '$count kare, hepsi karanlık';
  }

  @override
  String get reelStart => 'İlk kareyi banyo et';

  @override
  String get inspectReveal => 'Bulamadım, göster';

  @override
  String get inspectNudge =>
      'Ayrıntının yeri hafifçe parlıyor. Büyüteci oraya götür.';

  @override
  String get caseStatusInProgress => 'DEVAM EDİYOR';

  @override
  String caseFramesProgress(int solved, int total) {
    return '$solved/$total kare';
  }

  @override
  String get resumeEyebrow => 'KALDIĞIN YER';

  @override
  String get resumeButton => 'Devam et';

  @override
  String resumeWhere(int reel, int frame) {
    return 'Rulo $reel · Kare $frame';
  }

  @override
  String resumeAt(int reel, int frame) {
    return 'Devam et · Rulo $reel · Kare $frame';
  }

  @override
  String reelWaiting(int reel, int next) {
    return 'Rulo $reel tamam. Rulo $next yakında.';
  }

  @override
  String get reelComingSoon => 'Sonraki rulo yakında';

  @override
  String questionEyebrow(int reel) {
    return 'RULO $reel SONU · TEORİN';
  }

  @override
  String get questionHint =>
      'Doğru cevabı şimdi öğrenmeyeceksin. Sonraki rulolar gösterecek.';

  @override
  String get questionSaved => 'Teorin deftere yazıldı.';

  @override
  String get questionNextReel => 'Sıradaki rulo';

  @override
  String get questionBackToDeveloping => 'Banyo\'ya dön';

  @override
  String resumeTheory(int reel) {
    return 'Rulo $reel sonu · teorin bekleniyor';
  }

  @override
  String get notebookTabPeople => 'Kişiler';

  @override
  String get notebookTabClues => 'İpuçları';

  @override
  String get notebookTabTimeline => 'Zaman';

  @override
  String get notebookTabTheories => 'Teoriler';

  @override
  String get notebookUnknownName => 'Bilinmeyen kişi';

  @override
  String get notebookUnknownPerson =>
      'Henüz tanışmadın. Fotoğraflarda karşına çıkacak.';

  @override
  String get notebookNoClues =>
      'Henüz ipucu yok. Fotoğrafları incelerken bulduğun ayrıntılar buraya yazılır.';

  @override
  String get notebookNoTimes => 'Fotoğraflarda saat buldukça buraya eklenir.';

  @override
  String get notebookTimelineHint =>
      'Saatlerin arasındaki boşluklara dikkat et.';

  @override
  String get notebookKnownFact => 'Bilinen';

  @override
  String notebookTheoryLabel(int reel) {
    return 'RULO $reel SONU';
  }

  @override
  String notebookTheoryPending(int reel) {
    return 'Rulo $reel bitince sorulacak.';
  }

  @override
  String get notebookTheoryHint =>
      'Teorilerin doğru mu, sonraki rulolar gösterecek.';

  @override
  String get notebookTapToClose => 'Kapatmak için dokun';

  @override
  String get caseStatusClosed => 'KAPANDI';

  @override
  String get caseReread => 'Kapanışı yeniden oku';

  @override
  String caseYourDecision(String decision) {
    return 'Kararın: $decision';
  }

  @override
  String get questionToFinale => 'Son karar';

  @override
  String get finaleConfirm => 'Kararımı verdim';

  @override
  String get backToCaseFiles => 'Dosyalara dön';

  @override
  String get notebookDecisionLabel => 'SON KARAR';

  @override
  String get welcomeEyebrow => 'KARANLIK ODA';

  @override
  String get welcomeTitle => 'Bir vasiyet';

  @override
  String get welcomeStart => 'Notu oku';

  @override
  String get tutorialEyebrow => 'NERMİN HANIM\'IN NOTU';

  @override
  String get tutorialTitle => 'Negatif okumak';

  @override
  String tutorialStepOf(int step, int total) {
    return 'ADIM $step / $total';
  }

  @override
  String get tutorialStep1 =>
      'Soldaki sayı, o satırda kaç kare dolu olduğunu söyler. En üst satırda 5 var: beşi de dolu. Parmağını satır boyunca sürükle.';

  @override
  String get tutorialStep2 =>
      'Üstteki sayılar sütunlar için aynısını söyler. En sağdaki sütun da 5. Onu da doldur.';

  @override
  String get tutorialStep3 =>
      '\"1 1\" iki ayrı dolu kare demek; aralarında boşluk var. İkinci satırın iki ucu dolu, ortası boş. Alttan \"İşaretle\"yi seç, boş olduğundan emin olduğun kareye × koy.';

  @override
  String get tutorialStep4 =>
      'Gerisini sen tamamla. Takılırsan ipucu bir satırı açar. Yanlış kare cezasız; kırmızı görünür.';

  @override
  String get tutorialDoneTitle => 'NEGATİF HAZIR';

  @override
  String get tutorialDoneBody =>
      'Bir fotoğraf çerçevesi. İlk dersin bu. Her karenin altında bir fotoğraf, her fotoğrafın içinde bir hikâye var.';

  @override
  String get tutorialOpenCabinet => 'Dolabı aç';

  @override
  String get sectionPrivacy => 'GİZLİLİK';

  @override
  String get privacyOptions => 'Gizlilik seçenekleri';

  @override
  String get privacyOptionsSubtitle => 'Reklam izinlerini değiştir';

  @override
  String get sectionHelp => 'YARDIM';

  @override
  String get replayTutorial => 'Öğreticiyi yeniden oyna';

  @override
  String get replayTutorialSubtitle => 'Giriş hikâyesi ve ilk bulmaca';

  @override
  String get splashTagline => 'Her fotoğrafın bir hikâyesi var.';
}
