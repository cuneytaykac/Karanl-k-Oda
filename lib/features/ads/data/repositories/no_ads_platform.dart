import '../../domain/repositories/ads_platform.dart';

/// Reklamsız ortam (testler): onay gerekmez, reklam da istenmez.
class NoAdsPlatform implements AdsPlatform {
  const NoAdsPlatform();

  @override
  Future<bool> start() async => false;

  @override
  Future<bool> privacyOptionsRequired() async => false;

  @override
  Future<void> showPrivacyOptions() async {}
}
