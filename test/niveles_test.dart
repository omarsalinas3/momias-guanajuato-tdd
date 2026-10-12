import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/estado_juego.dart';
import 'package:momias_guanajuato/logica/motor_juego.dart';
import 'package:momias_guanajuato/logica/niveles.dart';

void main() {
  test('el juego tiene al menos dos niveles', () {
    expect(Niveles.total, greaterThanOrEqualTo(2));
  });

  test('cada llamada a crear devuelve un motor nuevo e independiente', () {
    final a = Niveles.crear(0);
    final b = Niveles.crear(0);
    expect(identical(a, b), false);
    a.vidas = 1;
    expect(b.vidas, 3);
  });

  test('el nivel 1 conserva las medidas originales', () {
    final nivel = Niveles.crear(0);
    expect(nivel.anchoNivel, 2000);
    expect(nivel.posicionMeta, 1900);
    expect(nivel.momias.length, 2);
  });

  test('el nivel 2 es mas largo y tiene mas plataformas, momias y calaveritas', () {
    final n1 = Niveles.crear(0);
    final n2 = Niveles.crear(1);
    expect(n2.anchoNivel, greaterThan(n1.anchoNivel));
    expect(n2.plataformas.length, greaterThan(n1.plataformas.length));
    expect(n2.momias.length, greaterThan(n1.momias.length));
    expect(n2.calaveritas.length, greaterThan(n1.calaveritas.length));
  });

  test('el nivel 2 incluye una momia que patrulla verticalmente', () {
    final n2 = Niveles.crear(1);
    expect(n2.momias.any((m) => m.limiteArriba != null && m.limiteAbajo != null), true);
  });

  test('todos los niveles usan el mismo MotorJuego y arrancan jugando con 3 vidas', () {
    for (var i = 0; i < Niveles.total; i++) {
      final motor = Niveles.crear(i);
      expect(motor, isA<MotorJuego>());
      expect(motor.estado, EstadoJuego.jugando);
      expect(motor.vidas, 3);
      expect(motor.posicionMeta, lessThan(motor.anchoNivel));
      expect(Niveles.nombre(i), isNotEmpty);
    }
  });

  test('crear con un indice invalido lanza un error', () {
    expect(() => Niveles.crear(Niveles.total), throwsRangeError);
  });
}
