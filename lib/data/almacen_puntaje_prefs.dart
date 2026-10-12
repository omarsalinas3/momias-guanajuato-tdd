import 'package:shared_preferences/shared_preferences.dart';
import '../logica/almacen_puntaje.dart';

class AlmacenPuntajePrefs implements AlmacenPuntaje {
  static const _clave = 'mejor_puntaje';

  @override
  Future<int> leer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clave) ?? 0;
  }

  @override
  Future<void> guardar(int puntaje) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_clave, puntaje);
  }
}
