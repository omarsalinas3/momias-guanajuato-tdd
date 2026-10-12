import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/data/almacen_puntaje_prefs.dart';
import 'package:momias_guanajuato/logica/almacen_puntaje.dart';
import 'package:momias_guanajuato/logica/mejor_puntaje.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlmacenEnMemoria implements AlmacenPuntaje {
  int valor;
  int escrituras = 0;
  AlmacenEnMemoria([this.valor = 0]);

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int puntaje) async {
    valor = puntaje;
    escrituras++;
  }
}

void main() {
  test('sin datos guardados el mejor puntaje es 0', () async {
    final gestor = GestorMejorPuntaje(AlmacenEnMemoria());
    await gestor.cargar();
    expect(gestor.mejor, 0);
  });

  test('cargar lee el mejor puntaje guardado', () async {
    final gestor = GestorMejorPuntaje(AlmacenEnMemoria(120));
    await gestor.cargar();
    expect(gestor.mejor, 120);
  });

  test('un puntaje mayor es nuevo record y se guarda', () async {
    final almacen = AlmacenEnMemoria(100);
    final gestor = GestorMejorPuntaje(almacen);
    await gestor.cargar();
    final esRecord = await gestor.registrar(150);
    expect(esRecord, true);
    expect(gestor.mejor, 150);
    expect(almacen.valor, 150);
  });

  test('un puntaje menor o igual no cambia el record ni escribe', () async {
    final almacen = AlmacenEnMemoria(100);
    final gestor = GestorMejorPuntaje(almacen);
    await gestor.cargar();
    expect(await gestor.registrar(50), false);
    expect(await gestor.registrar(100), false);
    expect(gestor.mejor, 100);
    expect(almacen.escrituras, 0);
  });

  test('AlmacenPuntajePrefs guarda y lee con shared_preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final almacen = AlmacenPuntajePrefs();
    expect(await almacen.leer(), 0);
    await almacen.guardar(250);
    expect(await almacen.leer(), 250);
  });
}
