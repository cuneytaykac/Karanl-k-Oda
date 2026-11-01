import 'package:flutter/painting.dart';

import 'colors.dart';

/// Yazı tipleri ve metin stilleri.
/// Lora: başlık/hikâye · Poppins: arayüz · JetBrainsMono: sayılar · Caveat: el yazısı.
abstract final class KoFont {
  static const lora = 'Lora';
  static const poppins = 'Poppins';
  static const mono = 'JetBrainsMono';
  static const handwriting = 'Caveat';
}

abstract final class KoText {
  // Başlıklar (Lora)
  static const display = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: KoColor.text);
  static const screenTitle = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: KoColor.text);
  static const sectionTitle = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: KoColor.text);
  static const cardTitle = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: KoColor.text);
  static const story = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: KoColor.text);
  static const quote = TextStyle(
      fontFamily: KoFont.lora,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      height: 1.5,
      color: KoColor.textCream);

  // Arayüz (Poppins)
  static const body = TextStyle(
      fontFamily: KoFont.poppins,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: KoColor.textCream);
  static const bodySmall = TextStyle(
      fontFamily: KoFont.poppins,
      fontSize: 12.5,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: KoColor.textMuted);
  static const label = TextStyle(
      fontFamily: KoFont.poppins,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.76,
      color: KoColor.textMuted); // BÜYÜK HARF kullan
  static const button = TextStyle(
      fontFamily: KoFont.poppins,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: KoColor.redButtonText);
  static const buttonSmall = TextStyle(
      fontFamily: KoFont.poppins,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: KoColor.text);
  static const bottomNav = TextStyle(
      fontFamily: KoFont.poppins, fontSize: 11, fontWeight: FontWeight.w500);

  // Sayılar (JetBrains Mono)
  static const hintCount = TextStyle(
      fontFamily: KoFont.mono,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: KoColor.text);
  static const counter = TextStyle(
      fontFamily: KoFont.mono,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: KoColor.textMuted);
  static const bigNumber = TextStyle(
      fontFamily: KoFont.mono,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: KoColor.text);

  // El yazısı (Caveat) — Nermin'in notları, defter teorileri
  static const handwriting = TextStyle(
      fontFamily: KoFont.handwriting,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: KoColor.ink);
}
