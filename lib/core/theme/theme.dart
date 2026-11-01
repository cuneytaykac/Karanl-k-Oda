import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions.dart';
import 'typography.dart';

export 'dimensions.dart';
export 'colors.dart';
export 'typography.dart';

/// Uygulamanın tek teması. Oyun yalnızca koyu temada çalışır.
ThemeData koTheme() {
  const colorScheme = ColorScheme.dark(
    primary: KoColor.redButton,
    onPrimary: KoColor.redButtonText,
    secondary: KoColor.amber,
    onSecondary: KoColor.ink,
    surface: KoColor.background,
    onSurface: KoColor.text,
    surfaceContainer: KoColor.surface,
    outline: KoColor.line,
    error: KoColor.redText,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: KoColor.background,
    fontFamily: KoFont.poppins,
    splashFactory: InkSparkle.splashFactory,
    textTheme: const TextTheme(
      displaySmall: KoText.display,
      headlineMedium: KoText.screenTitle,
      headlineSmall: KoText.sectionTitle,
      titleMedium: KoText.cardTitle,
      bodyMedium: KoText.body,
      bodySmall: KoText.bodySmall,
      labelSmall: KoText.label,
      labelLarge: KoText.button,
    ),
    dividerTheme:
        const DividerThemeData(color: KoColor.line, thickness: 1, space: 1),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(KoColor.redButtonText),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? KoColor.redButton
            : KoColor.lineStrong,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: KoColor.surface,
      showDragHandle: true,
      dragHandleColor: KoColor.ghostBorder,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(KoRadius.sheet)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: KoColor.paper,
      contentTextStyle:
          TextStyle(fontFamily: KoFont.poppins, color: KoColor.ink),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
