import 'almacen_puntaje.dart';

class GestorMejorPuntaje {
  final AlmacenPuntaje _almacen;
  int mejor = 0;

  GestorMejorPuntaje(this._almacen);

  Future<void> cargar() async {
    mejor = await _almacen.leer();
  }

  /// Devuelve true si [puntaje] supera el record y lo guarda.
  Future<bool> registrar(int puntaje) async {
    if (puntaje <= mejor) return false;
    mejor = puntaje;
    await _almacen.guardar(puntaje);
    return true;
  }
}
