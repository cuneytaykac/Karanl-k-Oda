/// Güvenlik ışığı renk süzgeci (ColorFilter.matrix).
///
/// [amount] 1 iken her şey kırmızı ışık altında (kırmızı tek renk), 0 iken gerçek renkler.
List<double> safelightMatrix(double amount) {
  const identity = <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
  // Parlaklığı (0.3R+0.59G+0.11B) kırmızı ağırlıklı bir tona dönüştür.
  const red = <double>[
    0.33,
    0.65,
    0.12,
    0,
    0,
    0.10,
    0.20,
    0.04,
    0,
    0,
    0.08,
    0.15,
    0.03,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
  return [
    for (var i = 0; i < 20; i++) identity[i] + (red[i] - identity[i]) * amount
  ];
}
