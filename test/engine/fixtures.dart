/// Rulo 2 · Kare 4 (oynanış videosundaki balık, 10×10).
const fish = [
  '..........',
  '..####...#',
  '.######.##',
  '##.#######',
  '##########',
  '##########',
  '.######.##',
  '..####...#',
  '...##.....',
  '..........',
];

/// Öğretici kare (7×7 saat). Tahminsiz çözülebildiği çözücüyle doğrulandı.
/// Not: kanvastaki ilk taslak (S06) tahminsiz çözülemiyordu; bu sürüm onun yerine geçer.
const tutorialClock = [
  '.#####.',
  '##...##',
  '#..#..#',
  '#..###.',
  '#.....#',
  '##...##',
  '.#####.',
];

/// Kanvastaki ilk öğretici taslağı — tek çözümlü DEĞİL. Çözücü bunu yakalamalı.
const oldTutorialDraft = [
  '..###..',
  '.#...#.',
  '#..#..#',
  '#..##.#',
  '#.....#',
  '.#...#.',
  '..###..',
];

/// İki çözümü olan en küçük bulmaca: ipuçları [1][1] / [1][1].
const ambiguous2x2 = ['#.', '.#'];
