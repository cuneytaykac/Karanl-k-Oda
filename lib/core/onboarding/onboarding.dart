import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// İlk açılış (giriş hikâyesi + öğretici bulmaca) bitti mi?
/// true: bitti, oyun doğrudan Banyo'dan açılır.
class OnboardingController extends Notifier<bool> {
  static const _flag = 'onboarded';
  Storage? _storage;

  @override
  bool build() {
    try {
      _storage = ref.read(storageProvider);
    } catch (_) {
      // Testlerde Storage verilmez: girişi atla, oyun doğrudan açılsın.
      return true;
    }
    return _storage!.readFlag(_flag);
  }

  void complete() {
    state = true;
    _storage?.writeFlag(_flag, true);
  }

  /// Ayarlar > Öğreticiyi yeniden oyna.
  void reset() {
    state = false;
    _storage?.writeFlag(_flag, false);
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);
