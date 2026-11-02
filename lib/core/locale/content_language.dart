import 'dart:ui';

import '../../l10n/l10n.dart';

/// Hikâye içeriğinin dili: arayüzle aynı kural. Telefonun tercih ettiği diller
/// sırayla denenir; desteklenen ilk dil seçilir, hiçbiri yoksa İngilizce.
String contentLanguage([List<Locale>? deviceLocales]) {
  final supported = {
    for (final l in AppLocalizations.supportedLocales) l.languageCode
  };
  for (final locale
      in deviceLocales ?? PlatformDispatcher.instance.locales) {
    if (supported.contains(locale.languageCode)) return locale.languageCode;
  }
  return 'en';
}
