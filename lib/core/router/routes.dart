/// Ekran adresleri tek yerde. Kanvastaki ekran numaraları yanlarında.
abstract final class Routes {
  static const developing = '/developing'; // 07–09
  static const caseFiles = '/case-files'; // 10–14
  static const notebook = '/notebook'; // 35–42
  static const settings = '/settings'; // 46
  static const welcome = '/welcome'; // ilk açılış: giriş hikâyesi
  static const tutorial = '/tutorial'; // ilk açılış: öğretici bulmaca
  static String caseDetail(String caseId) => '/case/$caseId'; // 11–14
  static String caseOpening(String caseId) => '/case/$caseId/opening'; // 15
  static String reelIntro(String caseId, int reel) =>
      '/reel/$caseId/$reel'; // 16
  static String puzzle(String caseId, int reel, int frame) =>
      '/puzzle/$caseId/$reel/$frame'; // 17
  static String negative(String caseId, int reel, int frame) =>
      '/negative/$caseId/$reel/$frame'; // 21
  static String develop(String caseId, int reel, int frame) =>
      '/develop/$caseId/$reel/$frame'; // 22
  static String scene(String caseId, int reel, int frame) =>
      '/scene/$caseId/$reel/$frame'; // kare sonrası hikâye anı
  static String question(String caseId, int reel) =>
      '/question/$caseId/$reel'; // 26
  static String finale(String caseId) => '/finale/$caseId'; // son karar
  static String ending(String caseId) =>
      '/ending/$caseId'; // seçime göre kapanış
  static String inspect(String caseId, int reel, int frame) =>
      '/inspect/$caseId/$reel/$frame'; // 23

  /// Bir rulodaki kare sayısı.
  static const framesPerReel = 10;
}
