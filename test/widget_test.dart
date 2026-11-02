import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/core/theme/theme.dart';

void main() {
  group('Ayarlar', () {
    test('varsayılanlar', () {
      const a = Settings();
      expect(a.music, isTrue);
      expect(Settings.hintsPerReel, 3);
    });

    test('JSON gidiş-dönüş bozulmuyor', () {
      final a = const Settings().copyWith(music: false, vibration: true);
      final b = Settings.fromJson(a.toJson());
      expect(b.music, isFalse);
      expect(b.vibration, isTrue);
    });

    test('bozuk kayıt varsayılana döner', () {
      // Eski sürümlerdeki "difficulty" ve "showMistakes" alanları yok sayılır.
      final a = Settings.fromJson(
          {'difficulty': 'easy', 'showMistakes': false, 'music': 'yes'});
      expect(a.music, isTrue);
      expect(a.toJson().containsKey('showMistakes'), isFalse);
    });
  });

  test('tema koyu ve fontlar doğru', () {
    final t = koTheme();
    expect(t.brightness.name, 'dark');
    expect(t.scaffoldBackgroundColor, KoColor.background);
    expect(KoText.screenTitle.fontFamily, KoFont.lora);
  });
}
