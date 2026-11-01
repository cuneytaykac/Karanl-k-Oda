import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/di/providers.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/features/ads/domain/entities/rewarded_ad_result.dart';
import 'package:karanlik_oda/features/ads/domain/usecases/ad_break_policy.dart';
import 'package:karanlik_oda/features/ads/presentation/providers/ads_coordinator.dart';
import 'package:karanlik_oda/features/progress/presentation/providers/progress_providers.dart';
import 'package:karanlik_oda/features/puzzle/presentation/view_model/puzzle_view_model.dart';

class _FixedSettings extends SettingsController {
  @override
  Settings build() => const Settings();
}

/// Sonucu testte seçilen sahte ödüllü reklam.
class _FakeRewarded implements RewardedAds {
  RewardedAdResult next = RewardedAdResult.earned;
  int shown = 0;
  @override
  void preload() {}
  @override
  Future<RewardedAdResult> show() async {
    shown++;
    return next;
  }
}

class _FakeInterstitial implements InterstitialAds {
  int shown = 0;
  @override
  void preload() {}
  @override
  Future<bool> show() async {
    shown++;
    return true;
  }
}

void main() {
  group('Rulo arası kuralları', () {
    const policy = AdBreakPolicy();
    final t0 = DateTime(2026, 1, 1, 12);

    test('ilk rulo reklamsız; 1. rulo bitince reklam olabilir', () {
      expect(policy.shouldShow(nextReel: 1, now: t0), isFalse);
      expect(policy.shouldShow(nextReel: 2, now: t0), isTrue);
    });

    test('iki geçiş reklamı arasında en az 10 dakika', () {
      final last = t0.subtract(const Duration(minutes: 9));
      expect(policy.shouldShow(nextReel: 3, now: t0, lastInterstitial: last),
          isFalse);
      expect(
          policy.shouldShow(
              nextReel: 3,
              now: t0,
              lastInterstitial: t0.subtract(const Duration(minutes: 10))),
          isTrue);
    });

    test('az önce ipucu reklamı izlendiyse atlanır', () {
      expect(
          policy.shouldShow(
              nextReel: 3,
              now: t0,
              lastRewarded: t0.subtract(const Duration(minutes: 1))),
          isFalse);
    });
  });

  group('Reklam koordinatörü', () {
    test('ödüllü reklamdan hemen sonra geçiş reklamı gösterilmez', () async {
      var now = DateTime(2026, 1, 1, 12);
      final rewarded = _FakeRewarded();
      final interstitial = _FakeInterstitial();
      final ads = AdsCoordinator(rewarded, interstitial, now: () => now);
      await ads.reelBreak(nextReel: 2);
      expect(interstitial.shown, 1);
      now = now.add(const Duration(minutes: 11));
      await ads.showRewarded();
      await ads.reelBreak(nextReel: 3);
      expect(interstitial.shown, 1, reason: 'ödüllü reklam az önce izlendi');
      now = now.add(const Duration(minutes: 4));
      await ads.reelBreak(nextReel: 3);
      expect(interstitial.shown, 2);
    });
  });

  group('Reklamla ipucu', () {
    const key = (caseId: 'wrong_man', reel: 2, frame: 4);
    late _FakeRewarded rewarded;
    late ProviderContainer c;

    setUp(() {
      rewarded = _FakeRewarded();
      c = ProviderContainer(overrides: [
        settingsProvider.overrideWith(_FixedSettings.new),
        rewardedAdsProvider.overrideWithValue(rewarded),
      ]);
      c.listen(puzzleViewModelProvider(key), (_, __) {});
    });
    tearDown(() => c.dispose());

    PuzzleViewModel vm() => c.read(puzzleViewModelProvider(key).notifier);
    PuzzleState state() => c.read(puzzleViewModelProvider(key));

    void spendHints() {
      for (var i = 0; i < Settings.hintsPerReel; i++) {
        vm().useHint();
      }
    }

    test('hak varken reklam teklif edilmez', () {
      expect(state().hintsLeft, 3);
      expect(state().adHintAvailable, isFalse);
    });

    test('hak bitince reklam izlenir, ipucu hemen kullanılır', () async {
      spendHints();
      expect(state().adHintAvailable, isTrue);
      final filledBefore = state().board.filledCount;
      expect(await vm().watchAdForHint(), AdHintOutcome.granted);
      expect(rewarded.shown, 1);
      expect(state().board.filledCount, greaterThan(filledBefore));
      expect(state().hintsLeft, 0);
      expect(state().hintsUsed, 4);
      expect(c.read(progressProvider)['wrong_man']!.adHints[2], 1);
    });

    test('reklam yarıda kapanırsa ipucu yok', () async {
      spendHints();
      rewarded.next = RewardedAdResult.dismissed;
      final filledBefore = state().board.filledCount;
      expect(await vm().watchAdForHint(), AdHintOutcome.dismissed);
      expect(state().board.filledCount, filledBefore);
      expect(state().adHintAvailable, isTrue, reason: 'tekrar denenebilir');
    });

    test('reklam yoksa oyuncu cezalandırılmaz: ipucu yine verilir', () async {
      spendHints();
      rewarded.next = RewardedAdResult.unavailable;
      expect(await vm().watchAdForHint(), AdHintOutcome.granted);
    });

    test('sınır yok: sonraki karede de reklamla ipucu alınabilir', () async {
      spendHints();
      await vm().watchAdForHint();
      await vm().watchAdForHint();
      await vm().watchAdForHint();
      // Aynı rulonun başka bir karesi: normal hak bitmiş, reklam yine açık.
      const next = (caseId: 'wrong_man', reel: 2, frame: 5);
      c.listen(puzzleViewModelProvider(next), (_, __) {});
      final s = c.read(puzzleViewModelProvider(next));
      expect(s.hintsLeft, 0);
      expect(s.adHintAvailable, isTrue);
    });
  });
}
