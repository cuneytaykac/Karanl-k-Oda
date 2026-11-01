/// Izgarada tek parmak: ilk değen parmak çizer, ötekiler yok sayılır.
///
/// View model'ler bunu tutar; ızgara widget'ı durumsuz kalır.
class StrokeGate {
  int? _pointer;

  /// Parmak çizmeye başlayabilir mi? Başlayabiliyorsa sahiplenir.
  bool claim(int pointer) {
    if (_pointer != null) return false;
    _pointer = pointer;
    return true;
  }

  /// Bu parmak çizen parmak mı?
  bool owns(int pointer) => _pointer == pointer;

  /// Çizen parmak kalktıysa true döner ve kapıyı açar.
  bool release(int pointer) {
    if (_pointer != pointer) return false;
    _pointer = null;
    return true;
  }
}
