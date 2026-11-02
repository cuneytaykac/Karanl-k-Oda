import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Oda'**
  String get appTitle;

  /// No description provided for @navDeveloping.
  ///
  /// In tr, this message translates to:
  /// **'Banyo'**
  String get navDeveloping;

  /// No description provided for @navCaseFiles.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalar'**
  String get navCaseFiles;

  /// No description provided for @navNotebook.
  ///
  /// In tr, this message translates to:
  /// **'Defter'**
  String get navNotebook;

  /// No description provided for @pageNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa bulunamadı: {uri}'**
  String pageNotFound(String uri);

  /// No description provided for @caseFilesEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'TESLİM EDİLMEYENLER'**
  String get caseFilesEyebrow;

  /// No description provided for @caseFilesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalar'**
  String get caseFilesTitle;

  /// No description provided for @caseFilesPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Dosya listesi burada olacak.'**
  String get caseFilesPlaceholder;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @sectionGame.
  ///
  /// In tr, this message translates to:
  /// **'OYUN'**
  String get sectionGame;

  /// No description provided for @hintsPerReel.
  ///
  /// In tr, this message translates to:
  /// **'Her rulo başında {count} ipucu.'**
  String hintsPerReel(int count);

  /// No description provided for @stuckHelp.
  ///
  /// In tr, this message translates to:
  /// **'Takılma yardımı'**
  String get stuckHelp;

  /// No description provided for @stuckHelpSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'2 dk ilerleme yoksa ücretsiz ipucu'**
  String get stuckHelpSubtitle;

  /// No description provided for @sectionSound.
  ///
  /// In tr, this message translates to:
  /// **'SES VE TİTREŞİM'**
  String get sectionSound;

  /// No description provided for @music.
  ///
  /// In tr, this message translates to:
  /// **'Müzik'**
  String get music;

  /// No description provided for @sfx.
  ///
  /// In tr, this message translates to:
  /// **'Efekt sesleri'**
  String get sfx;

  /// No description provided for @vibration.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get vibration;

  /// No description provided for @sectionNotifications.
  ///
  /// In tr, this message translates to:
  /// **'BİLDİRİM'**
  String get sectionNotifications;

  /// No description provided for @newCaseNotification.
  ///
  /// In tr, this message translates to:
  /// **'Yeni dosya bildirimi'**
  String get newCaseNotification;

  /// No description provided for @newCaseNotificationSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Dolaba yeni film gelince haber ver'**
  String get newCaseNotificationSubtitle;

  /// No description provided for @puzzleBackLabel.
  ///
  /// In tr, this message translates to:
  /// **'Banyoya dön'**
  String get puzzleBackLabel;

  /// No description provided for @puzzleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rulo {reel} · Kare {frame}'**
  String puzzleTitle(int reel, int frame);

  /// No description provided for @puzzleGridPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Izgara · Aşama 1'**
  String get puzzleGridPlaceholder;

  /// No description provided for @brandDark.
  ///
  /// In tr, this message translates to:
  /// **'KARANLIK '**
  String get brandDark;

  /// No description provided for @brandRoom.
  ///
  /// In tr, this message translates to:
  /// **'ODA'**
  String get brandRoom;

  /// No description provided for @developingHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Dolap seni bekliyor.'**
  String get developingHeadline;

  /// No description provided for @developingSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Nermin Hanım’ın teslim etmediği filmlerden birini seç.'**
  String get developingSubtitle;

  /// No description provided for @openCaseFiles.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalara bak'**
  String get openCaseFiles;

  /// No description provided for @debugPuzzle.
  ///
  /// In tr, this message translates to:
  /// **'Deneme bulmacası'**
  String get debugPuzzle;

  /// No description provided for @notebookEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'SORUŞTURMA'**
  String get notebookEyebrow;

  /// No description provided for @notebookTitle.
  ///
  /// In tr, this message translates to:
  /// **'Defter'**
  String get notebookTitle;

  /// No description provided for @notebookEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Defterin boş'**
  String get notebookEmptyTitle;

  /// No description provided for @notebookEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir dosya açtığında bulduğun her şey buraya kendiliğinden yazılır.'**
  String get notebookEmptyBody;

  /// No description provided for @goToCaseFiles.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalara git'**
  String get goToCaseFiles;

  /// No description provided for @puzzleToolFill.
  ///
  /// In tr, this message translates to:
  /// **'Doldur'**
  String get puzzleToolFill;

  /// No description provided for @puzzleToolCross.
  ///
  /// In tr, this message translates to:
  /// **'İşaretle'**
  String get puzzleToolCross;

  /// No description provided for @puzzleUndo.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get puzzleUndo;

  /// No description provided for @puzzleHint.
  ///
  /// In tr, this message translates to:
  /// **'İpucu · {count}'**
  String puzzleHint(int count);

  /// No description provided for @puzzleClear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get puzzleClear;

  /// No description provided for @puzzleHintAd.
  ///
  /// In tr, this message translates to:
  /// **'+1 İpucu'**
  String get puzzleHintAd;

  /// No description provided for @puzzleAdDismissed.
  ///
  /// In tr, this message translates to:
  /// **'Reklam yarıda kaldı; ipucu verilmedi.'**
  String get puzzleAdDismissed;

  /// No description provided for @puzzleNoHints.
  ///
  /// In tr, this message translates to:
  /// **'İpucun kalmadı. Kendin çözebilirsin.'**
  String get puzzleNoHints;

  /// No description provided for @puzzleSolvedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Negatif hazır.'**
  String get puzzleSolvedTitle;

  /// No description provided for @puzzleSolvedBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir şey belirdi.'**
  String get puzzleSolvedBody;

  /// No description provided for @puzzleSeePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı gör'**
  String get puzzleSeePhoto;

  /// No description provided for @puzzleHelp.
  ///
  /// In tr, this message translates to:
  /// **'Dokun ya da sürükle. Takılırsan ipucu hatalarını gösterir.'**
  String get puzzleHelp;

  /// No description provided for @puzzleGridLabel.
  ///
  /// In tr, this message translates to:
  /// **'{width}×{height} bulmaca ızgarası'**
  String puzzleGridLabel(int width, int height);

  /// No description provided for @puzzleContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get puzzleContinue;

  /// No description provided for @negativeEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'RULO {reel} · KARE {frame}'**
  String negativeEyebrow(int reel, int frame);

  /// No description provided for @negativeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Negatif hazır'**
  String get negativeTitle;

  /// No description provided for @negativeImageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanmış film negatifi'**
  String get negativeImageLabel;

  /// No description provided for @negativeHint.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafta ne olduğunu ancak banyoda göreceksin.'**
  String get negativeHint;

  /// No description provided for @statTime.
  ///
  /// In tr, this message translates to:
  /// **'süre'**
  String get statTime;

  /// No description provided for @statHints.
  ///
  /// In tr, this message translates to:
  /// **'ipucu'**
  String get statHints;

  /// No description provided for @statFrame.
  ///
  /// In tr, this message translates to:
  /// **'rulo'**
  String get statFrame;

  /// No description provided for @developButton.
  ///
  /// In tr, this message translates to:
  /// **'Banyo et'**
  String get developButton;

  /// No description provided for @skip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get skip;

  /// No description provided for @developingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Banyo tepsisinde beliren fotoğraf'**
  String get developingSemantics;

  /// No description provided for @developingProgress.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf beliriyor…'**
  String get developingProgress;

  /// No description provided for @developingDone.
  ///
  /// In tr, this message translates to:
  /// **'Hazır.'**
  String get developingDone;

  /// No description provided for @developingTapToSpeed.
  ///
  /// In tr, this message translates to:
  /// **'Hızlandırmak için dokun'**
  String get developingTapToSpeed;

  /// No description provided for @developedPhotoLabel.
  ///
  /// In tr, this message translates to:
  /// **'Banyo edilmiş fotoğraf'**
  String get developedPhotoLabel;

  /// No description provided for @done.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get done;

  /// No description provided for @inspectHint.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafta bir ayrıntı var. Parmağınla dolaş; büyüteç bir şeye takılınca anlarsın.'**
  String get inspectHint;

  /// No description provided for @inspectSkip.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik geç'**
  String get inspectSkip;

  /// No description provided for @inspectAddToNotebook.
  ///
  /// In tr, this message translates to:
  /// **'Deftere ekle · Kare {frame}'**
  String inspectAddToNotebook(int frame);

  /// No description provided for @inspectNextFrame.
  ///
  /// In tr, this message translates to:
  /// **'Kare {frame}'**
  String inspectNextFrame(int frame);

  /// No description provided for @inspectPhotoLabel.
  ///
  /// In tr, this message translates to:
  /// **'İncelenen fotoğraf. Büyüteçle gezmek için parmağını sürükle.'**
  String get inspectPhotoLabel;

  /// No description provided for @caseNumber.
  ///
  /// In tr, this message translates to:
  /// **'DOSYA {number}'**
  String caseNumber(int number);

  /// No description provided for @caseStatusNew.
  ///
  /// In tr, this message translates to:
  /// **'YENİ'**
  String get caseStatusNew;

  /// No description provided for @caseComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get caseComingSoon;

  /// No description provided for @casePeopleCount.
  ///
  /// In tr, this message translates to:
  /// **'KİŞİLER · {count}'**
  String casePeopleCount(int count);

  /// No description provided for @caseOpen.
  ///
  /// In tr, this message translates to:
  /// **'Dosyayı aç'**
  String get caseOpen;

  /// No description provided for @caseOneAtATime.
  ///
  /// In tr, this message translates to:
  /// **'Bir seferde bir dosya. Yarıda bırakırsan kaldığın yerden sürer.'**
  String get caseOneAtATime;

  /// No description provided for @caseOpenBag.
  ///
  /// In tr, this message translates to:
  /// **'Torbayı aç'**
  String get caseOpenBag;

  /// No description provided for @tapToContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için dokun'**
  String get tapToContinue;

  /// No description provided for @reelOf.
  ///
  /// In tr, this message translates to:
  /// **'RULO {reel} / {total}'**
  String reelOf(int reel, int total);

  /// No description provided for @reelFrames.
  ///
  /// In tr, this message translates to:
  /// **'{count} kare, hepsi karanlık'**
  String reelFrames(int count);

  /// No description provided for @reelStart.
  ///
  /// In tr, this message translates to:
  /// **'İlk kareyi banyo et'**
  String get reelStart;

  /// No description provided for @inspectReveal.
  ///
  /// In tr, this message translates to:
  /// **'Bulamadım, göster'**
  String get inspectReveal;

  /// No description provided for @inspectNudge.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntının yeri hafifçe parlıyor. Büyüteci oraya götür.'**
  String get inspectNudge;

  /// No description provided for @caseStatusInProgress.
  ///
  /// In tr, this message translates to:
  /// **'DEVAM EDİYOR'**
  String get caseStatusInProgress;

  /// No description provided for @caseFramesProgress.
  ///
  /// In tr, this message translates to:
  /// **'{solved}/{total} kare'**
  String caseFramesProgress(int solved, int total);

  /// No description provided for @resumeEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'KALDIĞIN YER'**
  String get resumeEyebrow;

  /// No description provided for @resumeButton.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get resumeButton;

  /// No description provided for @resumeWhere.
  ///
  /// In tr, this message translates to:
  /// **'Rulo {reel} · Kare {frame}'**
  String resumeWhere(int reel, int frame);

  /// No description provided for @resumeAt.
  ///
  /// In tr, this message translates to:
  /// **'Devam et · Rulo {reel} · Kare {frame}'**
  String resumeAt(int reel, int frame);

  /// No description provided for @reelWaiting.
  ///
  /// In tr, this message translates to:
  /// **'Rulo {reel} tamam. Rulo {next} yakında.'**
  String reelWaiting(int reel, int next);

  /// No description provided for @reelComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki rulo yakında'**
  String get reelComingSoon;

  /// No description provided for @questionEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'RULO {reel} SONU · TEORİN'**
  String questionEyebrow(int reel);

  /// No description provided for @questionHint.
  ///
  /// In tr, this message translates to:
  /// **'Doğru cevabı şimdi öğrenmeyeceksin. Sonraki rulolar gösterecek.'**
  String get questionHint;

  /// No description provided for @questionSaved.
  ///
  /// In tr, this message translates to:
  /// **'Teorin deftere yazıldı.'**
  String get questionSaved;

  /// No description provided for @questionNextReel.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki rulo'**
  String get questionNextReel;

  /// No description provided for @questionBackToDeveloping.
  ///
  /// In tr, this message translates to:
  /// **'Banyo\'ya dön'**
  String get questionBackToDeveloping;

  /// No description provided for @resumeTheory.
  ///
  /// In tr, this message translates to:
  /// **'Rulo {reel} sonu · teorin bekleniyor'**
  String resumeTheory(int reel);

  /// No description provided for @notebookTabPeople.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get notebookTabPeople;

  /// No description provided for @notebookTabClues.
  ///
  /// In tr, this message translates to:
  /// **'İpuçları'**
  String get notebookTabClues;

  /// No description provided for @notebookTabTimeline.
  ///
  /// In tr, this message translates to:
  /// **'Zaman'**
  String get notebookTabTimeline;

  /// No description provided for @notebookTabTheories.
  ///
  /// In tr, this message translates to:
  /// **'Teoriler'**
  String get notebookTabTheories;

  /// No description provided for @notebookUnknownName.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen kişi'**
  String get notebookUnknownName;

  /// No description provided for @notebookUnknownPerson.
  ///
  /// In tr, this message translates to:
  /// **'Henüz tanışmadın. Fotoğraflarda karşına çıkacak.'**
  String get notebookUnknownPerson;

  /// No description provided for @notebookNoClues.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ipucu yok. Fotoğrafları incelerken bulduğun ayrıntılar buraya yazılır.'**
  String get notebookNoClues;

  /// No description provided for @notebookNoTimes.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflarda saat buldukça buraya eklenir.'**
  String get notebookNoTimes;

  /// No description provided for @notebookTimelineHint.
  ///
  /// In tr, this message translates to:
  /// **'Saatlerin arasındaki boşluklara dikkat et.'**
  String get notebookTimelineHint;

  /// No description provided for @notebookKnownFact.
  ///
  /// In tr, this message translates to:
  /// **'Bilinen'**
  String get notebookKnownFact;

  /// No description provided for @notebookTheoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'RULO {reel} SONU'**
  String notebookTheoryLabel(int reel);

  /// No description provided for @notebookTheoryPending.
  ///
  /// In tr, this message translates to:
  /// **'Rulo {reel} bitince sorulacak.'**
  String notebookTheoryPending(int reel);

  /// No description provided for @notebookTheoryHint.
  ///
  /// In tr, this message translates to:
  /// **'Teorilerin doğru mu, sonraki rulolar gösterecek.'**
  String get notebookTheoryHint;

  /// No description provided for @notebookTapToClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapatmak için dokun'**
  String get notebookTapToClose;

  /// No description provided for @caseStatusClosed.
  ///
  /// In tr, this message translates to:
  /// **'KAPANDI'**
  String get caseStatusClosed;

  /// No description provided for @caseReread.
  ///
  /// In tr, this message translates to:
  /// **'Kapanışı yeniden oku'**
  String get caseReread;

  /// No description provided for @caseYourDecision.
  ///
  /// In tr, this message translates to:
  /// **'Kararın: {decision}'**
  String caseYourDecision(String decision);

  /// No description provided for @questionToFinale.
  ///
  /// In tr, this message translates to:
  /// **'Son karar'**
  String get questionToFinale;

  /// No description provided for @finaleConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Kararımı verdim'**
  String get finaleConfirm;

  /// No description provided for @backToCaseFiles.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalara dön'**
  String get backToCaseFiles;

  /// No description provided for @notebookDecisionLabel.
  ///
  /// In tr, this message translates to:
  /// **'SON KARAR'**
  String get notebookDecisionLabel;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'KARANLIK ODA'**
  String get welcomeEyebrow;

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir vasiyet'**
  String get welcomeTitle;

  /// No description provided for @welcomeLine1.
  ///
  /// In tr, this message translates to:
  /// **'Geçen kış, kasabanın eski fotoğrafçısı Nermin Hanım öldü.'**
  String get welcomeLine1;

  /// No description provided for @welcomeLine2.
  ///
  /// In tr, this message translates to:
  /// **'Vasiyetinde senin adın geçiyor.'**
  String get welcomeLine2;

  /// No description provided for @welcomeLine3.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Oda\'yı, çocukken bir kez gelip bana \"Işık nereye gidiyor?\" diye soran küçüğe bırakıyorum.'**
  String get welcomeLine3;

  /// No description provided for @welcomeLine4.
  ///
  /// In tr, this message translates to:
  /// **'Bir sabah anahtarı alıp kepengi kaldırıyorsun. İçerisi kimyasal kokuyor; tavanda kırmızı bir lamba.'**
  String get welcomeLine4;

  /// No description provided for @welcomeLine5.
  ///
  /// In tr, this message translates to:
  /// **'Arka tarafta bir dolap var. Kapağında el yazısıyla: \"Teslim edilmeyenler.\" İçinde, sahibine hiç verilmemiş onlarca film.'**
  String get welcomeLine5;

  /// No description provided for @welcomeLine6.
  ///
  /// In tr, this message translates to:
  /// **'Tezgâhta, senin için bırakılmış bir not duruyor.'**
  String get welcomeLine6;

  /// No description provided for @welcomeLine7.
  ///
  /// In tr, this message translates to:
  /// **'Filmler banyo edilmeyi bekliyor. Ama önce negatif okumayı öğren. Kenardaki sayılar her şeyi söyler; gerisi sabır.'**
  String get welcomeLine7;

  /// No description provided for @devSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get devSkip;

  /// No description provided for @welcomeStart.
  ///
  /// In tr, this message translates to:
  /// **'Notu oku'**
  String get welcomeStart;

  /// No description provided for @tutorialEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'NERMİN HANIM\'IN NOTU'**
  String get tutorialEyebrow;

  /// No description provided for @tutorialTitle.
  ///
  /// In tr, this message translates to:
  /// **'Negatif okumak'**
  String get tutorialTitle;

  /// No description provided for @tutorialStepOf.
  ///
  /// In tr, this message translates to:
  /// **'ADIM {step} / {total}'**
  String tutorialStepOf(int step, int total);

  /// No description provided for @tutorialStep1.
  ///
  /// In tr, this message translates to:
  /// **'Soldaki sayı, o satırda kaç kare dolu olduğunu söyler. En üst satırda 5 var: beşi de dolu. Parmağını satır boyunca sürükle.'**
  String get tutorialStep1;

  /// No description provided for @tutorialStep2.
  ///
  /// In tr, this message translates to:
  /// **'Üstteki sayılar sütunlar için aynısını söyler. En sağdaki sütun da 5. Onu da doldur.'**
  String get tutorialStep2;

  /// No description provided for @tutorialStep3.
  ///
  /// In tr, this message translates to:
  /// **'\"1 1\" iki ayrı dolu kare demek; aralarında boşluk var. İkinci satırın iki ucu dolu, ortası boş. Alttan \"İşaretle\"yi seç, boş olduğundan emin olduğun kareye × koy.'**
  String get tutorialStep3;

  /// No description provided for @tutorialStep4.
  ///
  /// In tr, this message translates to:
  /// **'Gerisini sen tamamla. Takılırsan ipucuna bas: önce hatalı kareleri gösterir, hata yoksa bir satırı açar.'**
  String get tutorialStep4;

  /// No description provided for @tutorialDoneTitle.
  ///
  /// In tr, this message translates to:
  /// **'NEGATİF HAZIR'**
  String get tutorialDoneTitle;

  /// No description provided for @tutorialDoneBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir fotoğraf çerçevesi. İlk dersin bu. Her karenin altında bir fotoğraf, her fotoğrafın içinde bir hikâye var.'**
  String get tutorialDoneBody;

  /// No description provided for @tutorialOpenCabinet.
  ///
  /// In tr, this message translates to:
  /// **'Dolabı aç'**
  String get tutorialOpenCabinet;

  /// No description provided for @sectionPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'GİZLİLİK'**
  String get sectionPrivacy;

  /// No description provided for @privacyOptions.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik seçenekleri'**
  String get privacyOptions;

  /// No description provided for @privacyOptionsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Reklam izinlerini değiştir'**
  String get privacyOptionsSubtitle;

  /// No description provided for @sectionHelp.
  ///
  /// In tr, this message translates to:
  /// **'YARDIM'**
  String get sectionHelp;

  /// No description provided for @replayTutorial.
  ///
  /// In tr, this message translates to:
  /// **'Öğreticiyi yeniden oyna'**
  String get replayTutorial;

  /// No description provided for @replayTutorialSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş hikâyesi ve ilk bulmaca'**
  String get replayTutorialSubtitle;

  /// No description provided for @splashTagline.
  ///
  /// In tr, this message translates to:
  /// **'Her fotoğrafın bir hikâyesi var.'**
  String get splashTagline;

  /// No description provided for @puzzleBlurred.
  ///
  /// In tr, this message translates to:
  /// **'Negatif bulanık çıktı. Bir yerde hata var; ipucu hatalı kareleri gösterir.'**
  String get puzzleBlurred;

  /// No description provided for @puzzleMistakesShown.
  ///
  /// In tr, this message translates to:
  /// **'Hatalı kareler kırmızıyla işaretlendi.'**
  String get puzzleMistakesShown;

  /// No description provided for @puzzleNoAd.
  ///
  /// In tr, this message translates to:
  /// **'Şu an reklam yüklenemedi. Biraz sonra tekrar dene.'**
  String get puzzleNoAd;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
