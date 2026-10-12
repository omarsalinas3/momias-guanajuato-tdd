import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/estado_juego.dart';
import 'package:momias_guanajuato/logica/motor_fisica.dart';
import 'package:momias_guanajuato/logica/motor_juego.dart';
import 'package:momias_guanajuato/logica/personaje.dart';
import 'package:momias_guanajuato/logica/rectangulo.dart';

void main() {
  const pared = Rectangulo(x: 200, y: 236, ancho: 40, alto: 64);

  test('caminar a la derecha contra una pared detiene al personaje en su borde izquierdo', () {
    final personaje = Personaje(x: 168, y: 250);
    final xAnterior = personaje.x;
    personaje.x += 10; // 178 + 32 = 210 > 200: entro en la pared
    MotorFisica.resolverColisionLateral(personaje, [pared], xAnterior);
    expect(personaje.x, 200 - personaje.ancho);
  });

  test('caminar a la izquierda contra una pared detiene al personaje en su borde derecho', () {
    final personaje = Personaje(x: 242, y: 250);
    final xAnterior = personaje.x;
    personaje.x -= 7; // 235 < 240: entro en la pared por la derecha
    MotorFisica.resolverColisionLateral(personaje, [pared], xAnterior);
    expect(personaje.x, 240);
  });

  test('sin interseccion la posicion horizontal no cambia', () {
    final personaje = Personaje(x: 50, y: 250);
    MotorFisica.resolverColisionLateral(personaje, [pared], 45);
    expect(personaje.x, 50);
  });

  test('estar parado sobre una plataforma no cuenta como choque lateral', () {
    const piso = Rectangulo(x: 0, y: 300, ancho: 2000, alto: 40);
    final personaje = Personaje(x: 105, y: 268); // pie en y=300, justo sobre el piso
    MotorFisica.resolverColisionLateral(personaje, [piso], 100);
    expect(personaje.x, 105);
  });

  test('integracion: el motor no deja atravesar una pared caminando', () {
    final personaje = Personaje(x: 150, y: 268);
    final motor = MotorJuego(
      personaje: personaje,
      plataformas: const [
        Rectangulo(x: 0, y: 300, ancho: 1000, alto: 20),
        pared,
      ],
      momias: const [],
      calaveritas: const [],
      posicionMeta: 900,
      anchoNivel: 1000,
    );
    for (var i = 0; i < 40; i++) {
      motor.mover(4);
    }
    expect(personaje.x, 200 - personaje.ancho);
    expect(motor.estado, EstadoJuego.jugando);
  });
}
