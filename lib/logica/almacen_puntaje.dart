/// Costura para persistir el mejor puntaje sin que la logica dependa de Flutter.
abstract class AlmacenPuntaje {
  Future<int> leer();
  Future<void> guardar(int puntaje);
}
