// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Karanlık Oda';

  @override
  String get navDeveloping => 'Developing';

  @override
  String get navCaseFiles => 'Case Files';

  @override
  String get navNotebook => 'Notebook';

  @override
  String pageNotFound(String uri) {
    return 'Page not found: $uri';
  }

  @override
  String get caseFilesEyebrow => 'UNCLAIMED';

  @override
  String get caseFilesTitle => 'Case Files';

  @override
  String get caseFilesPlaceholder => 'The case list will appear here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get back => 'Back';

  @override
  String hintsPerReel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hints at the start of each reel.',
      one: '1 hint at the start of each reel.',
    );
    return '$_temp0';
  }

  @override
  String get sectionSound => 'SOUND AND VIBRATION';

  @override
  String get music => 'Music';

  @override
  String get sfx => 'Sound effects';

  @override
  String get vibration => 'Vibration';

  @override
  String get puzzleBackLabel => 'Back to developing';

  @override
  String puzzleTitle(int reel, int frame) {
    return 'Reel $reel · Frame $frame';
  }

  @override
  String get puzzleGridPlaceholder => 'Grid · Stage 1';

  @override
  String get brandDark => 'KARANLIK ';

  @override
  String get brandRoom => 'ODA';

  @override
  String get developingHeadline => 'The cabinet is waiting for you.';

  @override
  String get developingSubtitle =>
      'Pick one of the films Mrs Nermin never handed in.';

  @override
  String get openCaseFiles => 'Browse case files';

  @override
  String get debugPuzzle => 'Test puzzle';

  @override
  String get notebookEyebrow => 'INVESTIGATION';

  @override
  String get notebookTitle => 'Notebook';

  @override
  String get notebookEmptyTitle => 'Your notebook is empty';

  @override
  String get notebookEmptyBody =>
      'Everything you find when you open a case is written here automatically.';

  @override
  String get goToCaseFiles => 'Go to case files';

  @override
  String get puzzleToolFill => 'Fill';

  @override
  String get puzzleToolCross => 'Mark';

  @override
  String get puzzleUndo => 'Undo';

  @override
  String puzzleHint(int count) {
    return 'Hint · $count';
  }

  @override
  String get puzzleClear => 'Clear';

  @override
  String get puzzleHintAd => '+1 Hint';

  @override
  String get puzzleAdDismissed =>
      'The ad was closed early, so no hint this time.';

  @override
  String get puzzleNoHints => 'No hints left. You can solve it yourself.';

  @override
  String get puzzleSolvedTitle => 'Negative ready.';

  @override
  String get puzzleSolvedBody => 'Something appeared.';

  @override
  String get puzzleSeePhoto => 'See the photo';

  @override
  String get puzzleHelp =>
      'Tap or drag. If you\'re stuck, a hint shows your mistakes.';

  @override
  String puzzleGridLabel(int width, int height) {
    return '$width×$height puzzle grid';
  }

  @override
  String get puzzleContinue => 'Continue';

  @override
  String negativeEyebrow(int reel, int frame) {
    return 'REEL $reel · FRAME $frame';
  }

  @override
  String get negativeTitle => 'Negative ready';

  @override
  String get negativeImageLabel => 'Finished film negative';

  @override
  String get negativeHint =>
      'You\'ll only see what\'s in the photo once it\'s developed.';

  @override
  String get statTime => 'time';

  @override
  String get statHints => 'hints';

  @override
  String get statFrame => 'reel';

  @override
  String get developButton => 'Develop';

  @override
  String get skip => 'Skip';

  @override
  String get developingSemantics => 'A photo appearing in the developing tray';

  @override
  String get developingProgress => 'The photo is appearing…';

  @override
  String get developingDone => 'Ready.';

  @override
  String get developingTapToSpeed => 'Tap to speed up';

  @override
  String get developedPhotoLabel => 'Developed photo';

  @override
  String get done => 'Done';

  @override
  String get inspectHint =>
      'There\'s a detail in the photo. Move your finger around; you\'ll know when the magnifier catches something.';

  @override
  String get inspectSkip => 'Skip for now';

  @override
  String inspectAddToNotebook(int frame) {
    return 'Add to notebook · Frame $frame';
  }

  @override
  String inspectNextFrame(int frame) {
    return 'Frame $frame';
  }

  @override
  String get inspectPhotoLabel =>
      'Photo under inspection. Drag your finger to move the magnifier.';

  @override
  String caseNumber(int number) {
    return 'FILE $number';
  }

  @override
  String get caseStatusNew => 'NEW';

  @override
  String get caseComingSoon => 'Coming soon';

  @override
  String casePeopleCount(int count) {
    return 'PEOPLE · $count';
  }

  @override
  String get caseOpen => 'Open the file';

  @override
  String get caseOneAtATime =>
      'One file at a time. Leave it and you\'ll pick up where you stopped.';

  @override
  String get caseOpenBag => 'Open the bag';

  @override
  String get tapToContinue => 'Tap to continue';

  @override
  String reelOf(int reel, int total) {
    return 'REEL $reel / $total';
  }

  @override
  String reelFrames(int count) {
    return '$count frames, all dark';
  }

  @override
  String get reelStart => 'Develop the first frame';

  @override
  String get inspectReveal => 'I can\'t find it, show me';

  @override
  String get inspectNudge =>
      'The detail is glowing faintly. Bring the loupe there.';

  @override
  String get caseStatusInProgress => 'IN PROGRESS';

  @override
  String caseFramesProgress(int solved, int total) {
    return '$solved/$total frames';
  }

  @override
  String get resumeEyebrow => 'WHERE YOU LEFT OFF';

  @override
  String get resumeButton => 'Continue';

  @override
  String resumeWhere(int reel, int frame) {
    return 'Reel $reel · Frame $frame';
  }

  @override
  String resumeAt(int reel, int frame) {
    return 'Continue · Reel $reel · Frame $frame';
  }

  @override
  String reelWaiting(int reel, int next) {
    return 'Reel $reel done. Reel $next coming soon.';
  }

  @override
  String get reelComingSoon => 'Next reel coming soon';

  @override
  String questionEyebrow(int reel) {
    return 'END OF REEL $reel · YOUR THEORY';
  }

  @override
  String get questionHint =>
      'You won\'t learn the answer now. The next reels will show you.';

  @override
  String get questionSaved => 'Your theory is in the notebook.';

  @override
  String get questionNextReel => 'Next reel';

  @override
  String get questionBackToDeveloping => 'Back to the darkroom';

  @override
  String resumeTheory(int reel) {
    return 'End of reel $reel · your theory awaits';
  }

  @override
  String get notebookTabPeople => 'People';

  @override
  String get notebookTabClues => 'Clues';

  @override
  String get notebookTabTimeline => 'Timeline';

  @override
  String get notebookTabTheories => 'Theories';

  @override
  String get notebookUnknownName => 'Unknown person';

  @override
  String get notebookUnknownPerson =>
      'You haven\'t met yet. They\'ll show up in the photos.';

  @override
  String get notebookNoClues =>
      'No clues yet. Details you find in the photos are written here.';

  @override
  String get notebookNoTimes => 'Times you find in the photos are added here.';

  @override
  String get notebookTimelineHint => 'Mind the gaps between the times.';

  @override
  String get notebookKnownFact => 'Known';

  @override
  String notebookTheoryLabel(int reel) {
    return 'END OF REEL $reel';
  }

  @override
  String notebookTheoryPending(int reel) {
    return 'You\'ll be asked when reel $reel ends.';
  }

  @override
  String get notebookTheoryHint =>
      'The next reels will show whether your theories hold.';

  @override
  String get notebookTapToClose => 'Tap to close';

  @override
  String get caseStatusClosed => 'CLOSED';

  @override
  String get caseReread => 'Read the ending again';

  @override
  String caseYourDecision(String decision) {
    return 'Your decision: $decision';
  }

  @override
  String get questionToFinale => 'Final decision';

  @override
  String get finaleConfirm => 'I\'ve decided';

  @override
  String get backToCaseFiles => 'Back to the files';

  @override
  String get notebookDecisionLabel => 'FINAL DECISION';

  @override
  String get welcomeEyebrow => 'KARANLIK ODA';

  @override
  String get welcomeTitle => 'A will';

  @override
  String get welcomeLine1 =>
      'Last winter, Mrs Nermin, the town\'s old photographer, passed away.';

  @override
  String get welcomeLine2 => 'Your name is in her will.';

  @override
  String get welcomeLine3 =>
      'I leave Karanlık Oda, my darkroom, to the little one who came in once, as a child, and asked me, \"Where does the light go?\"';

  @override
  String get welcomeLine4 =>
      'One morning you take the key and roll up the shutter. The air smells of chemicals; a red lamp hangs from the ceiling.';

  @override
  String get welcomeLine5 =>
      'At the back there is a cabinet. On its door, in handwriting: \"Never collected.\" Inside, dozens of films that never reached their owners.';

  @override
  String get welcomeLine6 => 'On the counter, a note has been left for you.';

  @override
  String get welcomeLine7 =>
      'The films are waiting to be developed. But first, learn to read a negative. The numbers on the edges tell you everything; the rest is patience.';

  @override
  String get devSkip => 'Skip';

  @override
  String get welcomeStart => 'Read the note';

  @override
  String get tutorialEyebrow => 'MRS NERMIN\'S NOTE';

  @override
  String get tutorialTitle => 'Reading a negative';

  @override
  String tutorialStepOf(int step, int total) {
    return 'STEP $step / $total';
  }

  @override
  String get tutorialStep1 =>
      'The number on the left tells how many cells in that row are filled. The top row says 5: all five. Drag your finger along the row.';

  @override
  String get tutorialStep2 =>
      'The numbers on top do the same for columns. The rightmost column is 5 too. Fill it.';

  @override
  String get tutorialStep3 =>
      '\"1 1\" means two separate filled cells with a gap between. The second row\'s ends are filled, its middle empty. Pick \"Mark\" below and put an × where you\'re sure it\'s empty.';

  @override
  String get tutorialStep4 =>
      'Finish the rest. If you\'re stuck, tap Hint: it shows your mistakes first, and if there are none, it reveals a row.';

  @override
  String get tutorialDoneTitle => 'NEGATIVE READY';

  @override
  String get tutorialDoneBody =>
      'A picture frame. Your first lesson. Under every frame is a photo; inside every photo, a story.';

  @override
  String get tutorialOpenCabinet => 'Open the cabinet';

  @override
  String get sectionPrivacy => 'PRIVACY';

  @override
  String get privacyOptions => 'Privacy options';

  @override
  String get privacyOptionsSubtitle => 'Change your ad consent';

  @override
  String get sectionHelp => 'HELP';

  @override
  String get replayTutorial => 'Replay the tutorial';

  @override
  String get replayTutorialSubtitle => 'The opening story and first puzzle';

  @override
  String get splashTagline => 'Every photograph has a story.';

  @override
  String get puzzleBlurred =>
      'The negative came out blurry. Something\'s wrong; a hint will show the wrong squares.';

  @override
  String get puzzleMistakesShown => 'The wrong squares are marked in red.';

  @override
  String get puzzleNoAd =>
      'No ad is available right now. Try again in a moment.';
}
