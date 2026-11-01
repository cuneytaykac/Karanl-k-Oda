import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/settings/settings.dart';
import 'package:karanlik_oda/core/theme/theme.dart';

void main() {
  group('Ayarlar', () {
    test('varsayılanlar', () {
      const a = Settings();
      expect(a.showMistakes, isTrue);
      expect(Settings.hintsPerReel, 3);
    });

    test('JSON gidiş-dönüş bozulmuyor', () {
      final a = const Settings().copyWith(showMistakes: false, vibration: true);
      final b = Settings.fromJson(a.toJson());
      expect(b.showMistakes, isFalse);
      expect(b.vibration, isTrue);
    });

    test('bozuk kayıt varsayılana döner', () {
      // Eski sürümdeki "difficulty" alanı yok sayılır.
      final a = Settings.fromJson({'difficulty': 'easy', 'music': 'yes'});
      expect(a.showMistakes, isTrue);
      expect(a.music, isTrue);
    });
  });

  test('tema koyu ve fontlar doğru', () {
    final t = koTheme();
    expect(t.brightness.name, 'dark');
    expect(t.scaffoldBackgroundColor, KoColor.background);
    expect(KoText.screenTitle.fontFamily, KoFont.lora);
  });
}
